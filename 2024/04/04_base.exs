# https://adventofcode.com/2024/day/4
# this is the version by hand
base_input =
  File.read!("input.txt")
  |> String.split("\n")
  |> Enum.map(&String.trim/1)
  |> Enum.filter(&(&1 != ""))

horizontal_xmas =
  base_input
  |> Enum.map(fn line ->
    Regex.scan(~r/XMAS/, line)
    |> length()
  end)
  |> Enum.sum()

horizontal_samx =
  base_input
  |> Enum.map(fn line ->
    Regex.scan(~r/SAMX/, line)
    |> length()
  end)
  |> Enum.sum()

graphemes =
  base_input
  |> Enum.map(&String.graphemes/1)
  |> Enum.with_index()

# Get grid dimensions
height = length(base_input)
width = String.length(Enum.at(base_input, 0))

# Check diagonals (top-left to bottom-right and top-right to bottom-left)
diagonal_patterns =
  for row <- 0..(height - 4),
      col <- 0..(width - 4) do
    # Get diagonal string from top-left to bottom-right
    diagonal_lr =
      0..3
      |> Enum.map(fn i ->
        graphemes
        |> Enum.at(row + i)
        |> elem(0)
        |> Enum.at(col + i)
      end)
      |> Enum.join()

    # Get diagonal string from top-right to bottom-left
    diagonal_rl =
      0..3
      |> Enum.map(fn i ->
        graphemes
        |> Enum.at(row + i)
        |> elem(0)
        |> Enum.at(col + (3 - i))
      end)
      |> Enum.join()

    {diagonal_lr, diagonal_rl}
  end

diagonal_xmas =
  diagonal_patterns
  |> Enum.reduce({0, 0}, fn {lr, rl}, {lr_count, rl_count} ->
    {
      if(lr == "XMAS", do: lr_count + 1, else: lr_count),
      if(rl == "XMAS", do: rl_count + 1, else: rl_count)
    }
  end)
  |> (fn {lr, rl} ->
        IO.inspect(lr, label: "XMAS Left-to-Right count")
        IO.inspect(rl, label: "XMAS Right-to-Left count")
        lr + rl
      end).()

diagonal_samx =
  diagonal_patterns
  |> Enum.reduce({0, 0}, fn {lr, rl}, {lr_count, rl_count} ->
    {
      if(lr == "SAMX", do: lr_count + 1, else: lr_count),
      if(rl == "SAMX", do: rl_count + 1, else: rl_count)
    }
  end)
  |> (fn {lr, rl} ->
        IO.inspect(lr, label: "SAMX Left-to-Right count")
        IO.inspect(rl, label: "SAMX Right-to-Left count")
        lr + rl
      end).()

# Check vertical patterns
vertical_patterns =
  for col <- 0..(width - 1),
      row <- 0..(height - 4) do
    0..3
    |> Enum.map(fn i ->
      graphemes
      |> Enum.at(row + i)
      |> elem(0)
      |> Enum.at(col)
    end)
    |> Enum.join()
  end

IO.inspect(horizontal_xmas, label: "Horizontal XMAS")
IO.inspect(horizontal_samx, label: "Horizontal SAMX")

vertical_xmas =
  vertical_patterns
  |> Enum.count(fn pattern -> pattern == "XMAS" end)
  |> IO.inspect(label: "Vertical XMAS")

vertical_samx =
  vertical_patterns
  |> Enum.count(fn pattern -> pattern == "SAMX" end)
  |> IO.inspect(label: "Vertical SAMX")

IO.inspect(diagonal_xmas, label: "Diagonal XMAS")
IO.inspect(diagonal_samx, label: "Diagonal SAMX")

(horizontal_xmas + horizontal_samx + diagonal_xmas + diagonal_samx + vertical_xmas + vertical_samx)
|> IO.inspect(label: "Total")
