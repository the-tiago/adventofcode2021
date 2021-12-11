defmodule AdventOfCode2021.Day5 do
  @moduledoc """
  Documentation for `AdventOfCode2021.Day5`.
  """

  alias AdventOfCode2021.Day5.Matrix

  @doc """
  https://adventofcode.com/2021/day/5
  ## Examples
    iex> AdventOfCode2021.Day5.part_1([{{0,9}, {5,9}}, {{8,0}, {0,8}}, {{9,4}, {3,4}}, {{2,2}, {2,1}}, {{7,0}, {7,4}}, {{6,4}, {2,0}}, {{0,9}, {2,9}}, {{3,4}, {1,4}}, {{0,0}, {8,8}}, {{5,5}, {8,2}}])
    5
  """
  def part_1(input) do
    matrix =
      input
      |> Enum.reduce(%Matrix{}, &process_line/2)

    matrix.data
    |> Enum.reduce(0, &count_intersections/2)
  end

  @doc """
  https://adventofcode.com/2021/day/5
  ## Examples
    iex> AdventOfCode2021.Day5.part_2([{{0,9}, {5,9}}, {{8,0}, {0,8}}, {{9,4}, {3,4}}, {{2,2}, {2,1}}, {{7,0}, {7,4}}, {{6,4}, {2,0}}, {{0,9}, {2,9}}, {{3,4}, {1,4}}, {{0,0}, {8,8}}, {{5,5}, {8,2}}])
    12
  """
  def part_2(input) do
    matrix =
      input
      |> Enum.reduce(%Matrix{}, &process_line(&1, &2, true))

    matrix.data
    |> Enum.reduce(0, &count_intersections/2)
  end

  defp count_intersections(elem, acc) do
    Enum.reduce(elem, acc, fn
      point, acc when point > 1 -> acc + 1
      _, acc -> acc
    end)
  end

  defp process_line(elem, matrix, diagonal \\ false) do
    matrix
    |> do_process_line(elem, diagonal)
  end

  defp do_process_line(matrix, {{x, y1}, {x, y2}}, _) do
    matrix
    |> grow_matrix_h(x)
    |> grow_matrix_v(max(y1, y2))
    |> process_vertical_line(x, min(y1, y2), max(y1, y2))
  end

  defp do_process_line(matrix, {{x1, y}, {x2, y}}, _) do
    matrix
    |> grow_matrix_h(max(x1, x2))
    |> grow_matrix_v(y)
    |> process_horizontal_line(y, min(x1, x2), max(x1, x2))
  end

  defp do_process_line(matrix, {{x1, y1}, {x2, y2}}, true)
       when abs(x1 - x2) == abs(y1 - y2) do
    process_diagonal_line(matrix, {x1, y1}, {x2, y2})
  end

  defp do_process_line(matrix, _, _), do: matrix

  defp process_diagonal_line(matrix, {x, y} = point, {x, y}) do
    process_line({point, point}, matrix, false)
  end

  defp process_diagonal_line(matrix, {x1, y1} = point, {x2, y2} = end_point) do
    process_line({point, point}, matrix, false)
    |> process_diagonal_line({walt_to_coord(x1, x2), walt_to_coord(y1, y2)}, end_point)
  end

  defp walt_to_coord(start, finish) when start < finish, do: start + 1
  defp walt_to_coord(start, finish) when start > finish, do: start - 1
  defp walt_to_coord(_start, finish), do: finish

  defp process_horizontal_line(matrix, y, x1, x2) do
    matrix
    |> Map.put(
      :data,
      matrix.data
      |> Enum.map_reduce(0, &find_horizontal_line_and_increase(&1, &2, y, x1, x2))
      |> elem(0)
    )
  end

  defp find_horizontal_line_and_increase(line, y, y, x1, x2) do
    {
      Enum.map_reduce(line, 0, &increase_horizontal_line(&1, &2, x1, x2))
      |> elem(0),
      y + 1
    }
  end

  defp find_horizontal_line_and_increase(line, index, _, _, _), do: {line, index + 1}

  defp increase_horizontal_line(elem, index, x1, x2) when index >= x1 and index <= x2,
    do: {elem + 1, index + 1}

  defp increase_horizontal_line(elem, index, _, _), do: {elem, index + 1}

  defp process_vertical_line(matrix, x, y1, y2) do
    matrix
    |> Map.put(
      :data,
      matrix.data
      |> Enum.map_reduce(0, &increase_vertical_line(&1, &2, x, y1, y2))
      |> elem(0)
    )
  end

  defp increase_vertical_line(elem, index, x, y1, y2) when index >= y1 and index <= y2,
    do: {List.update_at(elem, x, &(&1 + 1)), index + 1}

  defp increase_vertical_line(elem, index, _, _, _), do: {elem, index + 1}

  defp grow_matrix_h(%Matrix{max_col: col} = matrix, x) when x <= col, do: matrix

  defp grow_matrix_h(matrix, x) do
    matrix
    |> Map.put(
      :data,
      matrix.data
      |> Enum.map(fn elem ->
        elem ++ List.duplicate(0, x - matrix.max_col)
      end)
    )
    |> Map.put(:max_col, x)
  end

  defp grow_matrix_v(%Matrix{max_row: row} = matrix, y) when y <= row, do: matrix

  defp grow_matrix_v(matrix, y) do
    append =
      for _n <- Map.get(matrix, :max_row)..(y - 1), do: List.duplicate(0, matrix.max_col + 1)

    matrix
    |> Map.put(
      :data,
      matrix.data ++ append
    )
    |> Map.put(:max_row, y)
  end

  @doc """
  Parse the content of the input file for this day.
  Returns a list of pairs of points
  """
  def parse_input(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&map_point_pair/1)
  end

  def map_point_pair(str) do
    [left | [right | []]] = String.split(str, " -> ", trim: true)

    {parse_point(left), parse_point(right)}
  end

  def parse_point(str) do
    [x | [y | []]] = String.split(str, ",", trim: true)
    {String.to_integer(x), String.to_integer(y)}
  end
end
