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
