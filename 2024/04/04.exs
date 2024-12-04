# https://adventofcode.com/2024/day/4
# this is the version what Cursor refactored
defmodule PatternFinder do
  @patterns ["XMAS", "SAMX"]
  @pattern_length 4

  def count_patterns(input_file) do
    grid =
      File.read!(input_file)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    [
      count_in_rows(grid),
      count_in_columns(grid),
      count_in_diagonals(grid)
    ]
    |> Enum.sum()
    |> IO.inspect(label: "Total")
  end

  defp count_in_rows(grid) do
    grid
    |> Enum.map(&Enum.join/1)
    |> count_patterns_in_strings()
    |> IO.inspect(label: "Horizontal")
  end

  defp count_in_columns(grid) do
    grid
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.join/1)
    |> count_patterns_in_strings()
    |> IO.inspect(label: "Vertical")
  end

  defp count_in_diagonals(grid) do
    height = length(grid)
    width = length(hd(grid))

    # Get all possible diagonals (both directions)
    diagonals =
      for row <- 0..(height - @pattern_length),
          col <- 0..(width - @pattern_length) do
        [
          # left-to-right
          get_diagonal(grid, row, col, 1),
          # right-to-left
          get_diagonal(grid, row, col + 3, -1)
        ]
      end
      |> List.flatten()

    count_patterns_in_strings(diagonals)
    |> IO.inspect(label: "Diagonal")
  end

  defp get_diagonal(grid, row, col, step) do
    0..3
    |> Enum.map(fn i ->
      grid |> Enum.at(row + i) |> Enum.at(col + i * step)
    end)
    |> Enum.join()
  end

  defp count_patterns_in_strings(strings) do
    strings
    |> Enum.flat_map(fn str ->
      @patterns
      |> Enum.map(fn pattern ->
        str |> String.split(pattern) |> length() |> Kernel.-(1)
      end)
    end)
    |> Enum.sum()
  end
end

PatternFinder.count_patterns("input.txt")
