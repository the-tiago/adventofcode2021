defmodule AdventOfCode2021.Day2 do
  @moduledoc """
  Documentation for `AdventOfCode2021.Day2`.
  """

  @doc """
  Receives a list of commands for moving forward horizontally,
  or increasing or decreasing the depth. The final result is the horizontal
  position multplied by the depth.

  ## Examples
    iex> AdventOfCode2021.Day2.part_1([{:forward, 5}, {:down, 5}, {:forward, 8}, {:up, 3}, {:down, 8}, {:forward, 2}])
    150
  """
  def part_1(input) do
    {horizontal, depth} =
      input
      |> Enum.reduce({0, 0}, &move(&1, &2))

    horizontal * depth
  end

  @doc """
  Receives a list of commands for moving forward horizontally,
  increasing or decreasing the aim, and changing the depth. The final
  result is the horizontal position multplied by the depth.

  ## Examples
    iex> AdventOfCode2021.Day2.part_2([{:forward, 5}, {:down, 5}, {:forward, 8}, {:up, 3}, {:down, 8}, {:forward, 2}])
    900
  """
  def part_2(input) do
    {horizontal, depth, _aim} =
      input
      |> Enum.reduce({0, 0, 0}, &move_and_aim(&1, &2))

    horizontal * depth
  end

  @doc """
  Parse the content of the input file for this day.
  Returns a list tuples. Each tuple has a command (:forward, :up or :down)
  and a Integer
  """
  def parse_input(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&convert_string_to_atom_and_integer/1)
  end

  defp convert_string_to_atom_and_integer(content) do
    [atom, int] = String.split(content)
    {String.to_atom(atom), String.to_integer(int)}
  end

  defp move({:forward, units}, {horizontal, depth}), do: {horizontal + units, depth}
  defp move({:down, units}, {horizontal, depth}), do: {horizontal, depth + units}
  defp move({:up, units}, {horizontal, depth}), do: {horizontal, depth - units}
  defp move(_unknown, {horizontal, depth}), do: {horizontal, depth}

  defp move_and_aim({:forward, units}, {horizontal, depth, aim}),
    do: {horizontal + units, depth + aim * units, aim}

  defp move_and_aim({:down, units}, {horizontal, depth, aim}),
    do: {horizontal, depth, aim + units}

  defp move_and_aim({:up, units}, {horizontal, depth, aim}), do: {horizontal, depth, aim - units}
  defp move_and_aim(_unknown, {horizontal, depth, aim}), do: {horizontal, depth, aim}
end
