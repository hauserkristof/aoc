# https://adventofcode.com/2024/day/4
# this is the version what Cursor refactored
defmodule PatternFinder do
  @patterns ["MAS", "SAM"]
  @pattern_length 3

  def count_patterns(input_file) do
    grid =
      File.read!(input_file)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    [
      count_crossing_diagonals(grid)
    ]
    |> Enum.sum()
    |> IO.inspect(label: "Total")
  end

  defp count_crossing_diagonals(grid) do
    height = length(grid)
    width = length(hd(grid))

    # We'll check 3x3 areas where diagonals could cross
    for row <- 0..(height - @pattern_length),
        col <- 0..(width - @pattern_length) do
      # Get both diagonals that could form an X
      left_diagonal = get_diagonal(grid, row, col, 1)
      right_diagonal = get_diagonal(grid, row, col + @pattern_length - 1, -1)

      # Calculate intersection point (middle position)
      intersection_row = row + 1
      intersection_col = col + 1

      # Check if there's an "A" at the intersection
      has_intersection_a = grid |> Enum.at(intersection_row) |> Enum.at(intersection_col) == "A"

      if has_intersection_a do
        count_matching_patterns(left_diagonal, right_diagonal)
      else
        0
      end
    end
    |> Enum.sum()
    |> IO.inspect(label: "Diagonal")
  end

  defp get_diagonal(grid, row, col, step) do
    0..(@pattern_length - 1)
    |> Enum.map(fn i ->
      grid |> Enum.at(row + i) |> Enum.at(col + i * step)
    end)
    |> Enum.join()
  end

  defp count_matching_patterns(left_diagonal, right_diagonal) do
    left_matches = count_patterns_in_string(left_diagonal)
    right_matches = count_patterns_in_string(right_diagonal)
    left_matches * right_matches
  end

  defp count_patterns_in_string(str) do
    @patterns
    |> Enum.map(fn pattern ->
      str |> String.split(pattern) |> length() |> Kernel.-(1)
    end)
    |> Enum.sum()
  end
end

PatternFinder.count_patterns("input.txt")
