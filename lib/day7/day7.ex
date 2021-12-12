defmodule AdventOfCode2021.Day7 do
  @moduledoc """
  Documentation for `AdventOfCode2021`.
  """

  @doc """
  https://adventofcode.com/2021/day/7

  ## Examples
    iex> AdventOfCode2021.Day7.part_1([16,1,2,0,4,2,7,1,2,14])
    37
  """
  def part_1(input) do
    min = Enum.min(input)
    max = Enum.max(input)

    min..max
    |> Enum.map(fn n -> compute_cost(input, n) end)
    |> Enum.min()
  end

  @doc """
  https://adventofcode.com/2021/day/6

  ## Examples
    iex> AdventOfCode2021.Day7.part_2([16,1,2,0,4,2,7,1,2,14])
    168
  """
  def part_2(input) do
    min = Enum.min(input)
    max = Enum.max(input)

    min..max
    |> Enum.map(fn n -> compute_cost_extra(input, n) end)
    |> Enum.min()
  end

  defp compute_cost(list, point) do
    Enum.reduce(list, 0, fn e, acc -> abs(e - point) + acc end)
  end

  defp compute_cost_extra(list, point) do
    Enum.reduce(list, 0, fn
      e, acc when e == point ->
        acc

      e, acc ->
        distance = abs(e - point)

        Enum.sum(1..distance) + acc
    end)
  end

  @doc """
  Parse the content of the input file for this day.
  Returns a list of integers
  """
  def parse_input(content) do
    content
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
