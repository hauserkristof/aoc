# Read the entire contents of input.txt file
File.read!("part_two.txt")

# Split the content into lines at newline characters
|> String.split("\n")

# Remove any whitespace from the beginning and end of each line
|> Enum.map(&String.trim/1)

# Remove any empty lines
|> Enum.filter(&(&1 != ""))

# Transform each line:
# - Split the line at 3 or more spaces using regex
# - Convert the resulting two numbers to integers
# - Return as a tuple {num1, num2}, or nil if invalid format
|> Enum.map(fn line ->
  case Regex.split(~r/\s{3,}/, line) do
    [first, second] -> {String.to_integer(first), String.to_integer(second)}
    _ -> nil
  end
end)

# Remove any nil values from the previous step
|> Enum.reject(&is_nil/1)

# Split the list of tuples into two separate lists
# [{1,2}, {3,4}] becomes {[1,3], [2,4]}
|> Enum.unzip()

# Process the two lists:
|> then(fn {first_numbers, second_numbers} ->
  second_number_frequency =
    Enum.frequencies(second_numbers)

  products =
    first_numbers
    |> Enum.map(fn first_number ->
      frequency = Map.get(second_number_frequency, first_number, 0)
      first_number * frequency
    end)
    |> IO.inspect(label: "Products")

  _similarity_score =
    Enum.sum(products)
    |> IO.inspect(label: "Similarity score")
end)
