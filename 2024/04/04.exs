# https://adventofcode.com/2024/day/4
# this is the version what Cursor refactored
defmodule PatternFinder do
  def count_patterns(input_file) do
    grid = parse_input(input_file)
    dimensions = get_dimensions(grid)

    [
      find_horizontal_patterns(grid),
      find_vertical_patterns(grid, dimensions),
      find_diagonal_patterns(grid, dimensions)
    ]
    |> Enum.sum()
    |> IO.inspect(label: "Total patterns found")
  end

  defp parse_input(file) do
    File.read!(file)
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.graphemes/1)
  end

  defp get_dimensions(grid) do
    %{
      height: length(grid),
      width: length(Enum.at(grid, 0))
    }
  end

  defp find_horizontal_patterns(grid) do
    patterns = ~w(XMAS SAMX)

    grid
    |> Enum.map(&Enum.join/1)
    |> Enum.map(fn line ->
      patterns
      |> Enum.map(fn pattern ->
        Regex.scan(~r/#{pattern}/, line) |> length()
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
    |> IO.inspect(label: "Horizontal patterns")
  end

  defp find_vertical_patterns(grid, %{height: height, width: width}) do
    patterns = ["XMAS", "SAMX"]

    for col <- 0..(width - 1),
        row <- 0..(height - 4) do
      0..3
      |> Enum.map(fn i -> Enum.at(grid, row + i) |> Enum.at(col) end)
      |> Enum.join()
    end
    |> Enum.count(fn pattern -> pattern in patterns end)
    |> IO.inspect(label: "Vertical patterns")
  end

  defp find_diagonal_patterns(grid, %{height: height, width: width}) do
    patterns = ["XMAS", "SAMX"]

    for row <- 0..(height - 4),
        col <- 0..(width - 4) do
      # Left to right diagonal
      lr_diagonal = get_diagonal(grid, row, col, :lr)
      # Right to left diagonal
      rl_diagonal = get_diagonal(grid, row, col + 3, :rl)

      Enum.count([lr_diagonal, rl_diagonal], fn pattern -> pattern in patterns end)
    end
    |> Enum.sum()
    |> IO.inspect(label: "Diagonal patterns")
  end

  defp get_diagonal(grid, row, col, direction) do
    0..3
    |> Enum.map(fn i ->
      col_index =
        case direction do
          :lr -> col + i
          :rl -> col - i
        end

      grid
      |> Enum.at(row + i)
      |> Enum.at(col_index)
    end)
    |> Enum.join()
  end
end

# Run the pattern finder
PatternFinder.count_patterns("input.txt")
