defmodule AdventOfCode2021.Day3 do
  @moduledoc """
  Documentation for `AdventOfCode2021.Day3`.
  """

  @doc """
  Receives a list of bit sets and compute the values for gamma
  and epsilon rates. For more information, go here:
  https://adventofcode.com/2021/day/3
  :)

  ## Examples
    iex> AdventOfCode2021.Day3.part_1([[0,0,1,0,0], [1,1,1,1,0], [1,0,1,1,0], [1,0,1,1,1], [1,0,1,0,1], [0,1,1,1,1], [0,0,1,1,1], [1,1,1,0,0], [1,0,0,0,0], [1,1,0,0,1], [0,0,0,1,0], [0,1,0,1,0]])
    198
  """
  def part_1(input) do
    significances =
      input
      |> Enum.reduce([], &compute_most_significative(&1, &2))

    gamma =
      significances
      |> Enum.map(&gamma_bit/1)
      |> Integer.undigits(2)

    epsilon =
      significances
      |> Enum.map(&epsilon_bit/1)
      |> Integer.undigits(2)

    gamma * epsilon
  end

  @doc """
  Ok, I quit to try to explain what each method does. Got to
  https://adventofcode.com/2021/day/3
  :)

  ## Examples
    iex> AdventOfCode2021.Day3.part_2([[0,0,1,0,0], [1,1,1,1,0], [1,0,1,1,0], [1,0,1,1,1], [1,0,1,0,1], [0,1,1,1,1], [0,0,1,1,1], [1,1,1,0,0], [1,0,0,0,0], [1,1,0,0,1], [0,0,0,1,0], [0,1,0,1,0]])
    230
  """
  def part_2(input) do
    oxygen =
      input
      |> find_one(0, :oxygen)
      |> Integer.undigits(2)

    co2 =
      input
      |> find_one(0, :co2)
      |> Integer.undigits(2)

    oxygen * co2
  end

  defp compute_most_significative([elem_head | elem_tail], [acc_head | acc_tail]) do
    [add_or_sub(elem_head, acc_head)] ++ compute_most_significative(elem_tail, acc_tail)
  end

  defp compute_most_significative([_elem_head | _elem_tail] = elem, []),
    do: compute_most_significative(elem, [0])

  defp compute_most_significative([], []), do: []

  defp add_or_sub(0, bit), do: bit - 1
  defp add_or_sub(1, bit), do: bit + 1

  defp gamma_bit(value) when value > 0, do: 1
  defp gamma_bit(value) when value < 0, do: 0

  defp epsilon_bit(value) when value > 0, do: 0
  defp epsilon_bit(value) when value < 0, do: 1

  defp find_one([single], _index, _type), do: single

  defp find_one(lst, index, type) do
    keep =
      lst
      |> Enum.map(&Enum.at(&1, index))
      |> Enum.reduce(0, &add_or_sub(&1, &2))
      |> bit_to_keep(type)

    lst
    |> Enum.filter(&(Enum.at(&1, index) == keep))
    |> find_one(index + 1, type)
  end

  defp bit_to_keep(significance, :oxygen) when significance >= 0, do: 1
  defp bit_to_keep(_significance, :oxygen), do: 0
  defp bit_to_keep(significance, :co2) when significance >= 0, do: 0
  defp bit_to_keep(_significance, :co2), do: 1
end
