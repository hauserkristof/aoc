File.read!("input.txt")
|> String.split("\n")
|> Enum.map(&String.trim/1)
|> Enum.filter(&(&1 != ""))
|> Enum.map(fn line ->
  case Regex.split(~r/\s{3,}/, line) do
    [first, second] -> {String.to_integer(first), String.to_integer(second)}
    _ -> nil
  end
end)
|> Enum.reject(&is_nil/1)
|> Enum.unzip()
|> then(fn {first_numbers, second_numbers} ->
  first_sorted = Enum.sort(first_numbers)
  second_sorted = Enum.sort(second_numbers)

  Enum.zip(first_sorted, second_sorted)
  |> Enum.map(fn {a, b} -> abs(a - b) end)
  |> Enum.sum()
  |> IO.inspect(label: "Sum of distances")
end)
