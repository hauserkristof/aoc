defmodule PrintQueue do
  # Parse the input into two parts: rules and updates
  def parse_input(input) do
    # Split the input into rules and updates based on the empty line
    [rules_part, updates_part] = String.split(input, "\n\n")

    # Parse rules into tuples {X, Y}, similar to an array of pairs in TypeScript
    rules =
      rules_part
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [first_page, later_page] = String.split(line, "|")
        {String.to_integer(first_page), String.to_integer(later_page)}
      end)

    # Parse updates into a list of arrays of integers
    updates =
      updates_part
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end

  # Check if a single update respects all ordering rules
  def valid_update?(update, rules) do
    Enum.all?(rules, fn {first_page, later_page} ->
      # Find the position of `x` and `y` in the update
      first_pos = Enum.find_index(update, &(&1 == first_page))
      later_pos = Enum.find_index(update, &(&1 == later_page))

      # If either page is missing or `x` appears before `y`, the rule is satisfied
      first_pos == nil or later_pos == nil or first_pos < later_pos
    end)
  end

  # Find the middle page of an update
  def middle_page(update) do
    # Get the page at the middle index (like `update[Math.floor(update.length / 2)]`)
    Enum.at(update, div(length(update), 2))
  end

  # Main function to solve the problem
  def solve(input) do
    # Parse the input into rules and updates
    {rules, updates} = parse_input(input)

    # Filter valid updates, calculate their middle pages, and sum them
    updates
    # Keep only updates that are valid
    |> Enum.filter(&valid_update?(&1, rules))
    # Get the middle page of each valid update
    |> Enum.map(&middle_page/1)
    # Sum all middle pages
    |> Enum.sum()
  end
end

File.read!("input.txt")
|> PrintQueue.solve()
|> IO.inspect()
