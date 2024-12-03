File.read!("input.txt")
|> String.split("\n")
|> Enum.map(&String.trim/1)
|> Enum.filter(&(&1 != ""))
# Join the lines, because the task is not to process each line, but the whole file
|> Enum.join("\n")
|> then(fn line ->
  # Remove everything between don't() and do(), or to end of line if no do()
  cleaned_line = Regex.replace(~r/don't\(\).*?(do\(\)|$)/s, line, "")
  IO.inspect(cleaned_line, label: "Cleaned Line")

  # Extract and process mul() expressions
  Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, cleaned_line)
  |> Enum.map(fn [_full_match, a, b] ->
    {String.to_integer(a), String.to_integer(b)}
  end)
  |> Enum.map(fn {a, b} -> a * b end)
end)
|> List.flatten()
|> Enum.sum()
|> IO.inspect(label: "Sum")
