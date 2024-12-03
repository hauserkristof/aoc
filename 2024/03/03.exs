File.read!("input.txt")
|> String.split("\n")
|> Enum.map(&String.trim/1)
|> Enum.filter(&(&1 != ""))
|> Enum.map(fn line ->
  Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, line)
  |> IO.inspect(label: "Matches")
  |> Enum.map(fn [_full_match, a, b] ->
    {String.to_integer(a), String.to_integer(b)}
  end)
  |> then(fn results ->
    results
    |> Enum.map(fn {a, b} -> a * b end)
  end)
  |> Enum.sum()
end)
|> Enum.sum()
|> IO.inspect(label: "Sum")
