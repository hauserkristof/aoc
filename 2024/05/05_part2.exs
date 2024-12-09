defmodule PrintQueue do
  # Parse the input into two parts: rules and updates
  def parse_input(input) do
    [rules_part, updates_part] = String.split(input, "\n\n")

    rules =
      rules_part
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [first_page, later_page] = String.split(line, "|")
        {String.to_integer(first_page), String.to_integer(later_page)}
      end)

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
      first_pos = Enum.find_index(update, &(&1 == first_page))
      later_pos = Enum.find_index(update, &(&1 == later_page))

      first_pos == nil or later_pos == nil or first_pos < later_pos
    end)
  end

  # Sort an update based on rules
  def sort_update(update, rules) do
    # Create a map of each page's "dependencies" (pages that must come before it)
    dependency_map =
      Enum.reduce(rules, %{}, fn {first_page, later_page}, acc ->
        Map.update(acc, later_page, [first_page], &[first_page | &1])
      end)

    # Sort the update using the dependency map
    Enum.sort(update, fn page_a, page_b ->
      depends_on?(page_a, page_b, dependency_map)
    end)
  end

  # Helper to determine if page_a should come before page_b
  defp depends_on?(page_a, page_b, dependency_map) do
    dependencies = Map.get(dependency_map, page_b, [])
    page_a in dependencies
  end

  # Find the middle page of an update
  def middle_page(update) do
    Enum.at(update, div(length(update), 2))
  end

  # Solve Part One: Sum of middle pages of valid updates
  def solve_part_one(input) do
    {rules, updates} = parse_input(input)

    updates
    |> Enum.filter(&valid_update?(&1, rules))
    |> Enum.map(&middle_page/1)
    |> Enum.sum()
  end

  # Solve Part Two: Sum of middle pages of corrected updates
  def solve_part_two(input) do
    {rules, updates} = parse_input(input)

    updates
    # Keep only invalid updates
    |> Enum.reject(&valid_update?(&1, rules))
    # Correct their order
    |> Enum.map(&sort_update(&1, rules))
    # Find the middle page of each corrected update
    |> Enum.map(&middle_page/1)
    # Sum the middle pages
    |> Enum.sum()
  end
end

File.read!("input.txt")
|> PrintQueue.solve_part_two()
|> IO.inspect()
