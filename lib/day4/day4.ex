defmodule AdventOfCode2021.Day4 do
  @moduledoc """
  Documentation for `AdventOfCode2021.Day4`.
  """

  alias AdventOfCode2021.Day4.Matrix

  @doc """
  https://adventofcode.com/2021/day/4
  Input is a tuple. The fist element is the list of drawn numbers. The
  second element is a list of the matrices. Each matrix is a list of rows.
  Each row is a list of numbers

  ## Examples
    iex> AdventOfCode2021.Day4.part_1(%{:numbers => [7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1], :matrices => [22, 13, 17, 11,  0, 8,  2, 23,  4, 24, 21,  9, 14, 16,  7, 6, 10,  3, 18,  5, 1, 12, 20, 15, 19, 3, 15, 0, 2, 22, 9, 18, 13, 17, 5, 19,  8, 7, 25, 23, 20, 11, 10, 24, 4, 14, 21, 16, 12, 6, 14, 21, 17, 24, 4, 10, 16, 15,  9, 19, 18,  8, 23, 26, 20, 22, 11, 13,  6,  5, 2,  0, 12,  3,  7]})
    4512
  """
  def part_1(%{:numbers => numbers, :matrices => raw_matrices}) do
    matrices =
      raw_matrices
      |> build_matrices([])

    numbers
    |> Enum.reduce_while(matrices, &play_bingo/2)
  end

  @doc """
  https://adventofcode.com/2021/day/4
  Not very proud of this solution :(
  ## Examples
    iex> AdventOfCode2021.Day4.part_2(%{:numbers => [7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1], :matrices => [22, 13, 17, 11,  0, 8,  2, 23,  4, 24, 21,  9, 14, 16,  7, 6, 10,  3, 18,  5, 1, 12, 20, 15, 19, 3, 15, 0, 2, 22, 9, 18, 13, 17, 5, 19,  8, 7, 25, 23, 20, 11, 10, 24, 4, 14, 21, 16, 12, 6, 14, 21, 17, 24, 4, 10, 16, 15,  9, 19, 18,  8, 23, 26, 20, 22, 11, 13,  6,  5, 2,  0, 12,  3,  7]})
    1924
  """
  def part_2(%{:numbers => numbers, :matrices => raw_matrices}) do
    matrices =
      raw_matrices
      |> build_matrices([])

    numbers
    |> Enum.reduce({0, matrices}, &play_reverse_bingo/2)
    |> elem(0)
  end

  defp build_matrices([], lst), do: lst

  defp build_matrices(raw_matrices, lst) do
    {left, right} = Enum.split(raw_matrices, 25)
    build_matrices(right, lst ++ [build_matrix(left)])
  end

  defp build_matrix(raw_numbers) do
    %Matrix{numbers: raw_numbers, count: Enum.reduce(raw_numbers, &(&1 + &2))}
  end

  defp play_bingo(number, matrices) do
    matrices
    |> Enum.map_reduce({:start, number}, &check_matrix/2)
    |> case do
      {_, {:won, number}} -> {:halt, number}
      {new_matrices, _} -> {:cont, new_matrices}
    end
  end

  defp check_matrix(matrix, {:won, number}), do: {matrix, {:won, number}}

  defp check_matrix(matrix, {_, number}) do
    case Enum.find_index(matrix.numbers, &(&1 == number)) do
      nil -> {matrix, {:cont, number}}
      index -> number_hit(matrix, number, index)
    end
  end

  defp number_hit(matrix, number, index) do
    # let's get the row number
    row = String.to_atom("row_" <> get_row_number(index))
    marked_in_row = Map.get(matrix, row) + 1
    col = String.to_atom("col_" <> Integer.to_string(rem(index, 5)))
    marked_in_col = Map.get(matrix, col) + 1
    count = Map.get(matrix, :count) - number

    new_matrix =
      matrix
      |> Map.put(row, marked_in_row)
      |> Map.put(col, marked_in_col)
      |> Map.put(:count, count)

    if marked_in_row == 5 or marked_in_col == 5 do
      {new_matrix, {:won, count * number}}
    else
      {new_matrix, {:cont, number}}
    end
  end

  defp play_reverse_bingo(number, {last_winner, matrices}) do
    {new_matrices, {winner, _}} =
      matrices
      |> Enum.map_reduce({last_winner, number}, &check_matrix2/2)

    {winner, new_matrices}
  end

  defp check_matrix2(matrix, {last_winner, number}) do
    case Enum.find_index(matrix.numbers, &(&1 == number)) do
      nil -> {matrix, {last_winner, number}}
      index -> number_hit2(matrix, last_winner, number, index)
    end
  end

  defp number_hit2(%Matrix{winner: true} = matrix, last_winner, number, _index),
    do: {matrix, {last_winner, number}}

  defp number_hit2(matrix, last_winner, number, index) do
    # let's get the row number
    row = String.to_atom("row_" <> get_row_number(index))
    marked_in_row = Map.get(matrix, row) + 1
    col = String.to_atom("col_" <> Integer.to_string(rem(index, 5)))
    marked_in_col = Map.get(matrix, col) + 1
    count = Map.get(matrix, :count) - number

    new_matrix =
      matrix
      |> Map.put(row, marked_in_row)
      |> Map.put(col, marked_in_col)
      |> Map.put(:count, count)

    if marked_in_row == 5 or marked_in_col == 5 do
      new_matrix = Map.put(new_matrix, :winner, true)
      {new_matrix, {count * number, number}}
    else
      {new_matrix, {last_winner, number}}
    end
  end

  defp get_row_number(index) when index < 5, do: "0"
  defp get_row_number(index) when index < 10, do: "1"
  defp get_row_number(index) when index < 15, do: "2"
  defp get_row_number(index) when index < 20, do: "3"
  defp get_row_number(_index), do: "4"

  @doc """
  Parse the content of the input file for this day.
  Returns a list of lists of integers
  """
  def parse_input(content) do
    [head | tail] =
      content
      |> String.split("\n", trim: true)

    numbers =
      head
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    matrices =
      tail
      |> Enum.reduce([], fn line, acc ->
        new_line =
          line
          |> String.split(" ", trim: true)
          |> Enum.map(&String.to_integer/1)

        acc ++ new_line
      end)

    %{:numbers => numbers, :matrices => matrices}
  end
end
