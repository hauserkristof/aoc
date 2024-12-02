defmodule SequenceValidator do
  # Checks if a sequence of numbers is strictly increasing or decreasing
  def is_monotonic?(numbers) do
    is_increasing =
      Enum.chunk_every(numbers, 2, 1, :discard)
      |> Enum.all?(fn [a, b] -> b > a end)

    is_decreasing =
      Enum.chunk_every(numbers, 2, 1, :discard)
      |> Enum.all?(fn [a, b] -> b < a end)

    is_increasing or is_decreasing
  end

  # Validates that adjacent numbers differ by 1-3
  def has_valid_distances?(numbers) do
    valid_distance_count =
      Enum.chunk_every(numbers, 2, 1, :discard)
      |> Enum.all?(fn [a, b] -> abs(a - b) >= 1 and abs(a - b) <= 3 end)

    valid_distance_count
  end

  def is_safe?(numbers) do
    is_monotonic?(numbers) and has_valid_distances?(numbers)
  end

  # Checks if sequence can be made safe by removing one number
  def is_safe_with_one_removal?(numbers) do
    # First check if sequence is already safe without removals
    if is_safe?(numbers) do
      true
    else
      # Try removing each number one at a time and check if result is safe
      0..(length(numbers) - 1)
      |> Enum.any?(fn index ->
        numbers_without_element = List.delete_at(numbers, index)
        is_safe?(numbers_without_element)
      end)
    end
  end
end

# Main program flow
File.read!("part_two.txt")
|> String.split("\n")
|> Enum.map(&String.trim/1)
# Remove empty lines
|> Enum.filter(&(&1 != ""))
|> (fn sequences ->
      total_count = length(sequences)
      {sequences, total_count}
    end).()
|> then(fn {sequences, total_count} ->
  sequences
  |> Enum.map(fn line ->
    case Regex.split(~r/\s/, line) do
      numbers ->
        numbers = Enum.map(numbers, &String.to_integer/1)

        IO.inspect(numbers, label: "Sequence", charlists: false)
        IO.inspect(length(numbers), label: "Count of numbers")

        is_safe = SequenceValidator.is_safe_with_one_removal?(numbers)

        IO.puts("#{if is_safe, do: "Safe", else: "Unsafe"}")
        IO.puts("----------------------------")
        {is_safe, numbers}

      _ ->
        nil
    end
  end)
  # Add line numbers
  |> Enum.with_index()
  # Keep only unsafe sequences
  |> Enum.filter(fn {{is_safe, _numbers}, _index} -> is_safe end)
  |> length()
  |> then(fn safe_count ->
    IO.puts("\nNumber of safe sequences: #{safe_count}")
  end)
end)
