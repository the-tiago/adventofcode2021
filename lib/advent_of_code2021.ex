defmodule AdventOfCode2021 do
  @moduledoc """
  Documentation for `AdventOfCode2021`.
  """

  alias AdventOfCode2021.Day1
  alias AdventOfCode2021.Day2
  alias AdventOfCode2021.Day3

  def day1_part1(), do: read_parse_and_execute(:day1, &parse_input_list/1, &Day1.part_1/1)
  def day1_part2(), do: read_parse_and_execute(:day1, &parse_input_list/1, &Day1.part_2/1)
  def day2_part1(), do: read_parse_and_execute(:day2, &parse_input_atom_integer/1, &Day2.part_1/1)
  def day2_part2(), do: read_parse_and_execute(:day2, &parse_input_atom_integer/1, &Day2.part_2/1)

  def day3_part1(),
    do: read_parse_and_execute(:day3, &parse_input_list_of_integers/1, &Day3.part_1/1)

  def day3_part2(),
    do: read_parse_and_execute(:day3, &parse_input_list_of_integers/1, &Day3.part_2/1)

  defp read_input_file(day) do
    :adventofcode2021
    |> :code.priv_dir()
    |> Path.join(Atom.to_string(day) <> ".input")
    |> File.read!()
  end

  defp parse_input_list(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_input_atom_integer(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&convert_string_to_atom_and_integer/1)
  end

  defp convert_string_to_atom_and_integer(content) do
    [atom, int] = String.split(content)
    {String.to_atom(atom), String.to_integer(int)}
  end

  defp parse_input_list_of_integers(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&convert_string_to_list_of_integers/1)
  end

  defp convert_string_to_list_of_integers(content) do
    content
    |> String.codepoints()
    |> Enum.map(&String.to_integer(&1))
  end

  defp read_parse_and_execute(day, parser, executor) do
    day
    |> read_input_file()
    |> parser.()
    |> executor.()
  end
end
