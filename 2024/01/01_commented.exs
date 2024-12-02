# Read the entire contents of input.txt file
File.read!("input.txt")

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
  # Sort both lists of numbers
  first_sorted = Enum.sort(first_numbers)
  second_sorted = Enum.sort(second_numbers)

  # Zip the sorted lists back together
  # Calculate absolute difference between each pair
  # Sum all differences
  # Output the result with a label
  Enum.zip(first_sorted, second_sorted)
  |> Enum.map(fn {a, b} -> abs(a - b) end)
  |> Enum.sum()
  |> IO.inspect(label: "Sum of distances")
end)
