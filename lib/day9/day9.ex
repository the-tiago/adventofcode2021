defmodule AdventOfCode2021.Day9 do
  @moduledoc """
  Documentation for `AdventOfCode2021`.
  """

  @doc """
  https://adventofcode.com/2021/day/9

  ## Examples
    iex> AdventOfCode2021.Day9.part_1([[2, 1, 9, 9, 9, 4, 3, 2, 1, 0], [3, 9, 8, 7, 8, 9, 4, 9, 2, 1], [9, 8, 5, 6, 7, 8, 9, 8, 9, 2], [8, 7, 6, 7, 8, 9, 6, 7, 8, 9], [9, 8, 9, 9, 9, 6, 5, 6, 7, 8]])
    15
  """
  def part_1(input) do
    input
    |> find_low_points()
    |> count_low_points()
  end

  defp find_low_points(matrix) do
    matrix
    |> Enum.reduce({0, []}, fn [first | tail], {y, acc} ->
      new_line = tail ++ [:edge]
      acc = find_horizontal_points(new_line, {:edge, :edge, first}, acc, 0, y)

      {y + 1, acc}
    end)
    |> elem(1)
    |> Enum.reduce({[], matrix}, &find_vertical_points/2)
    |> elem(0)
  end

  defp count_low_points(low_points) do
    low_points
    |> Enum.reduce(0, fn elem, acc ->
      acc + elem[:value] + 1
    end)
  end

  defp find_vertical_points(low_point, {acc, matrix}) do
    acc =
      case low_point do
        [x: x, y: 0, value: value] ->
          {:edge, value, get_point(matrix, x, 1)}

        [x: x, y: y, value: value] when y == length(matrix) - 1 ->
          {get_point(matrix, x, y - 1), value, :edge}

        [x: x, y: y, value: value] ->
          {get_point(matrix, x, y - 1), value, get_point(matrix, x, y + 1)}
      end
      |> case do
        {:edge, center, bottom} when center < bottom -> acc ++ [low_point]
        {top, center, :edge} when center < top -> acc ++ [low_point]
        {top, center, bottom} when center < top and center < bottom -> acc ++ [low_point]
        _ -> acc
      end

    {acc, matrix}
  end

  defp get_point(matrix, x, y) do
    matrix
    |> Enum.at(y)
    |> Enum.at(x)
  end

  defp find_horizontal_points([first | line_tail], troika, acc, x, y) do
    troika =
      troika
      |> Tuple.delete_at(0)
      |> Tuple.append(first)

    case troika do
      {:edge, center, right} when center < right ->
        {:continue, acc ++ [[x: x, y: y, value: center]]}

      {left, center, :edge} when left > center ->
        {:halt, acc ++ [[x: x, y: y, value: center]]}

      {_left, _center, :edge} ->
        {:halt, acc}

      {left, center, right} when left > center and center < right ->
        {:continue, acc ++ [[x: x, y: y, value: center]]}

      _ ->
        {:continue, acc}
    end
    |> case do
      {:continue, acc} -> find_horizontal_points(line_tail, troika, acc, x + 1, y)
      {:halt, acc} -> acc
    end
  end

  @doc """
  https://adventofcode.com/2021/day/9

  ## Examples
    iex> AdventOfCode2021.Day9.part_2([[2, 1, 9, 9, 9, 4, 3, 2, 1, 0], [3, 9, 8, 7, 8, 9, 4, 9, 2, 1], [9, 8, 5, 6, 7, 8, 9, 8, 9, 2], [8, 7, 6, 7, 8, 9, 6, 7, 8, 9], [9, 8, 9, 9, 9, 6, 5, 6, 7, 8]])
    1134
  """
  def part_2(input) do
    input
    |> find_low_points()
    |> find_basins(input)
    |> top_three_multiplied()
  end

  defp top_three_multiplied(basins) do
    basins
    |> Enum.map(&Enum.count(&1))
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(&(&1 * &2))
  end

  defp find_basins(low_points, matrix) do
    low_points
    |> Enum.map(
      &find_basin(%{}, matrix, &1[:x], &1[:y], -1, length(Enum.at(matrix, 0)), length(matrix))
    )
  end

  defp find_basin(basin, _matrix, -1, _y, _value, _width, _height), do: basin
  defp find_basin(basin, _matrix, _x, -1, _value, _width, _height), do: basin
  defp find_basin(basin, _matrix, x, _y, _value, width, _height) when x == width, do: basin
  defp find_basin(basin, _matrix, _x, y, _value, _width, height) when y == height, do: basin

  defp find_basin(basin, matrix, x, y, value, width, height) do
    case Map.get(basin, {x, y}) do
      nil ->
        case get_point(matrix, x, y) do
          9 ->
            basin

          new_value when new_value > value ->
            basin
            |> Map.put({x, y}, new_value)
            |> find_basin(matrix, x - 1, y, value, width, height)
            |> find_basin(matrix, x + 1, y, value, width, height)
            |> find_basin(matrix, x, y - 1, value, width, height)
            |> find_basin(matrix, x, y + 1, value, width, height)

          _ ->
            basin
        end

      _value ->
        basin
    end
  end

  @doc """
  Parse the content of the input file for this day.
  Returns a list of lists of integers
  """
  def parse_input(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&convert_string_to_list_of_integers/1)
  end

  defp convert_string_to_list_of_integers(content) do
    content
    |> String.codepoints()
    |> Enum.map(&String.to_integer(&1))
  end
end
