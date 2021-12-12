defmodule AdventOfCode2021.Day6 do
  @moduledoc """
  Documentation for `AdventOfCode2021`.

  My first approach has exponentional growth. It works well for the first part (80 days),
  but for the second part (256 days) it simply doesn't.

  After banging my head in the wall for hours, I gave up and took a look at
  Daniel Silva's (https://github.com/DFilipeS) solution.

  For the sake of fairness, I'll leave both solutions here, mine for part one
  and the other based on Daniel's work for part two.
  """

  @doc """
  https://adventofcode.com/2021/day/6

  ## Examples
    iex> AdventOfCode2021.Day6.part_1([3,4,3,1,2])
    5934
  """
  def part_1(input) do
    input
    |> Enum.reduce(length(input), fn
      counter, total -> compute_offspring(counter, total, 80)
    end)
  end

  @doc """
  https://adventofcode.com/2021/day/6

  ## Examples
    iex> AdventOfCode2021.Day6.part_2([3,4,3,1,2])
    26984457539
  """
  def part_2(input) do
    compute_linear(input, 256)
  end

  defp compute_offspring(counter, total, days_left) when days_left >= 0 do
    next_spawn = days_left - counter - 1

    first_generation = spwaning_days(next_spawn, [])

    first_generation
    |> Enum.reduce(total + length(first_generation), fn
      day, new_total -> compute_offspring(8, new_total, day)
    end)
  end

  defp compute_offspring(_counter, total, _days_left), do: total

  defp spwaning_days(n, acc) when n >= 0, do: acc ++ [n] ++ spwaning_days(n - 7, acc)
  defp spwaning_days(_, _), do: []

  defp compute_linear(input, days) do
    # map with number of fishes per counter
    agg =
      input
      |> Enum.reduce(%{}, fn elem, acc ->
        Map.update(acc, elem, 1, &(&1 + 1))
      end)

    # now process day by day
    agg =
      1..days
      |> Enum.reduce(agg, fn _, agg ->
        process_day_linear(agg)
      end)

    # count all the fishes
    agg
    |> Enum.reduce(0, fn {_, count}, acc -> acc + count end)
  end

  defp process_day_linear(agg) do
    agg
    |> Enum.reduce(%{}, fn
      {0, count}, acc ->
        acc
        |> Map.update(6, count, &(&1 + count))
        |> Map.update(8, count, &(&1 + count))

      {age, count}, acc ->
        acc
        |> Map.update(age - 1, count, &(&1 + count))
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
