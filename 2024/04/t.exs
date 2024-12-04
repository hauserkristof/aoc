defmodule WordSearch do
  # Counts the occurrences of a given word in a grid of letters
  def count_occurrences(grid, word) do
    # Define possible directions to search for the word
    directions = [
      # Horizontal right
      {1, 0},
      # Horizontal left
      {-1, 0},
      # Vertical down
      {0, 1},
      # Vertical up
      {0, -1},
      # Diagonal down-right
      {1, 1},
      # Diagonal up-left
      {-1, -1},
      # Diagonal down-left
      {1, -1},
      # Diagonal up-right
      {-1, 1}
    ]

    # Initialize a map to store the sum of counts for each direction
    direction_sums =
      Enum.reduce(directions, %{}, fn direction, acc ->
        Map.put(acc, direction, 0)
      end)

    # Iterate over each row and column in the grid
    grid
    |> Enum.with_index()
    |> Enum.reduce(direction_sums, fn {row, row_index}, acc ->
      String.graphemes(row)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {_char, col_index}, acc ->
        directions
        |> Enum.reduce(acc, fn direction, acc ->
          count = count_word(grid, row_index, col_index, direction, word)
          Map.update!(acc, direction, &(&1 + count))
        end)
      end)
    end)
    |> IO.inspect(label: "Sum of occurrences by direction")
  end

  # Checks if the word exists starting from a given position in a specific direction
  defp count_word(grid, start_x, start_y, {delta_x, delta_y}, word) do
    word
    |> String.graphemes()
    |> Enum.reduce_while({start_x, start_y, true}, fn char, {current_x, current_y, is_valid} ->
      # Continue if the current position is valid and matches the character
      if is_valid && in_bounds?(grid, current_x, current_y) &&
           String.at(Enum.at(grid, current_x), current_y) == char do
        {:cont, {current_x + delta_x, current_y + delta_y, true}}
      else
        {:halt, {current_x, current_y, false}}
      end
    end)
    |> case do
      # Word found
      {_final_x, _final_y, true} -> 1
      # Word not found
      _ -> 0
    end
  end

  # Checks if a position is within the bounds of the grid
  defp in_bounds?(grid, x, y) do
    x >= 0 && y >= 0 && x < length(grid) && y < String.length(Enum.at(grid, 0))
  end
end

# Read the grid from a file and split it into lines
grid =
  File.read!("input.txt")
  |> String.split("\n")

# Define the word to search for
word = "XMAS"

# Output the number of occurrences of the word in the grid
direction_counts = WordSearch.count_occurrences(grid, word)
total_occurrences = direction_counts |> Map.values() |> Enum.sum()
IO.puts("Occurrences of '#{word}': #{total_occurrences}")
