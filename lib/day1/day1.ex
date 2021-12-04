defmodule AdventOfCode2021.Day1 do
  @moduledoc """
  Documentation for `AdventOfCode2021`.
  """

  @doc """
  receives a list of mesurements and returns the number of times that
  a mesurement increases in relation to the previous one.

  ## Examples
    iex> AdventOfCode2021.Day1.part_1([199, 200, 208, 210, 200, 207, 240, 269, 260, 263])
    7
  """
  def part_1(input) do
    input
    |> Enum.reduce({:start, 0}, &process_measurement(&1, &2))
    |> elem(1)
  end

  @doc """
  receives a list of mesurements and returns the number of times that
  a window of 3 consecutive mesurements increases in relation to the previous
  window of measurements.

  ## Examples
    iex> AdventOfCode2021.Day1.part_2([199, 200, 208, 210, 200, 207, 240, 269, 260, 263])
    5
  """
  def part_2(input) do
    {_triad, lst} = Enum.reduce(input, {[], []}, &compute_windows(&1, &2))

    part_1(lst)
  end

  @doc """
  Parse the content of the input file for this day.
  Returns a list of integers
  """
  def parse_input(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp process_measurement(el, {_, :start}), do: {el, 0}
  defp process_measurement(el, {previous, acc}) when el > previous, do: {el, acc + 1}
  defp process_measurement(el, {_previous, acc}), do: {el, acc}

  defp compute_windows(el, {triad, lst}) when length(triad) < 2, do: {[el] ++ triad, lst}

  defp compute_windows(el, {triad, lst}) do
    window = Enum.take([el] ++ triad, 3)
    {window, lst ++ [Enum.reduce(window, 0, &(&1 + &2))]}
  end
end
