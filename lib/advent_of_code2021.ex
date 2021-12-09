defmodule AdventOfCode2021 do
  @moduledoc """
  Documentation for `AdventOfCode2021`.
  """

  alias AdventOfCode2021.Day1
  alias AdventOfCode2021.Day2
  alias AdventOfCode2021.Day3
  alias AdventOfCode2021.Day4

  def day1_part1(), do: read_parse_and_execute(:day1, &Day1.parse_input/1, &Day1.part_1/1)
  def day1_part2(), do: read_parse_and_execute(:day1, &Day1.parse_input/1, &Day1.part_2/1)
  def day2_part1(), do: read_parse_and_execute(:day2, &Day2.parse_input/1, &Day2.part_1/1)
  def day2_part2(), do: read_parse_and_execute(:day2, &Day2.parse_input/1, &Day2.part_2/1)

  def day3_part1(),
    do: read_parse_and_execute(:day3, &Day3.parse_input/1, &Day3.part_1/1)

  def day3_part2(),
    do: read_parse_and_execute(:day3, &Day3.parse_input/1, &Day3.part_2/1)

  def day4_part1(),
    do: read_parse_and_execute(:day4, &Day4.parse_input/1, &Day4.part_1/1)

  def day4_part2(),
    do: read_parse_and_execute(:day4, &Day4.parse_input/1, &Day4.part_2/1)

  defp read_input_file(day) do
    :adventofcode2021
    |> :code.priv_dir()
    |> Path.join(Atom.to_string(day) <> ".input")
    |> File.read!()
  end

  defp read_parse_and_execute(day, parser, executor) do
    day
    |> read_input_file()
    |> parser.()
    |> executor.()
  end
end
