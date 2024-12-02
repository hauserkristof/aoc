# Read the entire contents of input.txt file
File.read!("input.txt")

# Split the content into lines at newline characters
|> String.split("\n")

# Remove any whitespace from the beginning and end of each line
|> Enum.map(&String.trim/1)

# Remove any empty lines
|> Enum.filter(&(&1 != ""))

# Transform each line:
# - Split the line at 1 spaces using regex
# - Convert the resulting numbers to integers
# - Return as a tuple, or nil if invalid format
|> Enum.map(fn line ->
  case Regex.split(~r/\s/, line) do
    numbers ->
      numbers = Enum.map(numbers, &String.to_integer/1)

      # Check if sequence is monotonic
      is_increasing =
        Enum.chunk_every(numbers, 2, 1, :discard)
        |> Enum.all?(fn [a, b] -> b > a end)

      is_decreasing =
        Enum.chunk_every(numbers, 2, 1, :discard)
        |> Enum.all?(fn [a, b] -> b < a end)

      is_monotonic = is_increasing or is_decreasing

      is_valid_distance =
        Enum.chunk_every(numbers, 2, 1, :discard)
        |> Enum.all?(fn [a, b] -> abs(a - b) >= 1 and abs(a - b) <= 3 end)

      IO.inspect(numbers, label: "Sequence", charlists: false)
      # IO.puts("Is increasing: #{is_increasing}")
      # IO.puts("Is decreasing: #{is_decreasing}")
      # IO.puts("Is monotonic: #{is_monotonic}")
      # IO.puts("Is valid distance: #{is_valid_distance}")

      is_safe = is_monotonic and is_valid_distance

      # Print Safe or Unsafe
      IO.puts("#{if is_safe, do: "Safe", else: "Unsafe"}")

      is_safe

    _ ->
      nil
  end
end)
|> Enum.count(&(&1 == true))
|> IO.inspect(label: "Number of safe sequences")
