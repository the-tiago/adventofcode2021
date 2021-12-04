defmodule AdventOfCode2021 do
  @moduledoc """
  Documentation for `AdventOfCode2021`.
  """

  alias AdventOfCode2021.Day1

  def day1_part1(), do: read_parse_and_execute(:day1, &Day1.part_1/1)
  def day1_part2(), do: read_parse_and_execute(:day1, &Day1.part_2/1)

  defp read_input_file(day) do
    :adventofcode2021
    |> :code.priv_dir()
    |> Path.join(Atom.to_string(day) <> ".input")
    |> File.read!()
  end

  defp parse_input(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp read_parse_and_execute(day, foo) do
    day
    |> read_input_file()
    |> parse_input()
    |> foo.()
  end
end
