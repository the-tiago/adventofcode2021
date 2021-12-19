defmodule AdventOfCode2021.Day11 do
  @moduledoc """
  Documentation for `AdventOfCode2021`.
  """

  @doc """
  https://adventofcode.com/2021/day/11

  ## Examples
    iex> AdventOfCode2021.Day11.part_1([[5, 4, 8, 3, 1, 4, 3, 2, 2, 3], [2, 7, 4, 5, 8, 5, 4, 7, 1, 1], [5, 2, 6, 4, 5, 5, 6, 1, 7, 3], [6, 1, 4, 1, 3, 3, 6, 1, 4, 6], [6, 3, 5, 7, 3, 8, 5, 4, 7, 8], [4, 1, 6, 7, 5, 2, 4, 6, 4, 5], [2, 1, 7, 6, 8, 4, 1, 7, 2, 1], [6, 8, 8, 2, 8, 8, 1, 1, 3, 4], [4, 8, 4, 6, 8, 4, 8, 5, 5, 4], [5, 2, 8, 3, 7, 5, 1, 5, 2, 6]])
    1656
  """
  def part_1(input) do
    input
    |> create_map_with_flag()
    |> compute_flashes(100, 0)
  end

  @doc """
  https://adventofcode.com/2021/day/11

  ## Examples
    iex> AdventOfCode2021.Day11.part_2([[5, 4, 8, 3, 1, 4, 3, 2, 2, 3], [2, 7, 4, 5, 8, 5, 4, 7, 1, 1], [5, 2, 6, 4, 5, 5, 6, 1, 7, 3], [6, 1, 4, 1, 3, 3, 6, 1, 4, 6], [6, 3, 5, 7, 3, 8, 5, 4, 7, 8], [4, 1, 6, 7, 5, 2, 4, 6, 4, 5], [2, 1, 7, 6, 8, 4, 1, 7, 2, 1], [6, 8, 8, 2, 8, 8, 1, 1, 3, 4], [4, 8, 4, 6, 8, 4, 8, 5, 5, 4], [5, 2, 8, 3, 7, 5, 1, 5, 2, 6]])
    195
  """
  def part_2(input) do
    input
    |> create_map_with_flag()
    |> compute_flashes_reverse(1, 0)
  end

  defp create_map_with_flag(input) do
    input
    |> Enum.map(fn e -> Enum.map(e, &{&1, false}) end)
  end

  defp compute_flashes_reverse(map, step, flashes) do
    map =
      map
      |> increase_energy_level_and_reset_flags()
      |> process_map()

    map
    |> check_sync()
    |> case do
      :not_sync ->
        compute_flashes_reverse(map, step + 1, count_flashes(map) + flashes)

      :sync ->
        step
    end
  end

  defp check_sync(map) do
    map
    |> Enum.reduce_while(false, fn
      line, _acc ->
        Enum.reduce_while(line, false, fn
          {x, _}, _acc when x > 0 -> {:halt, :not_sync}
          {_, _}, _acc -> {:cont, :sync}
        end)
        |> case do
          :not_sync -> {:halt, :not_sync}
          :sync -> {:cont, :sync}
        end
    end)
  end

  defp compute_flashes(_map, 0, flashes), do: flashes

  defp compute_flashes(map, steps, flashes) do
    map =
      map
      |> increase_energy_level_and_reset_flags()
      |> process_map()

    # print_map(map)

    map
    |> compute_flashes(steps - 1, count_flashes(map) + flashes)
  end

  defp increase_energy_level_and_reset_flags(map) do
    map
    |> Enum.map(fn
      e ->
        Enum.map(e, fn
          {count, _} -> {count + 1, false}
        end)
    end)
  end

  defp process_map(map) do
    map =
      map
      |> check_flashes()

    map
    |> still_to_process()
    |> case do
      true -> process_map(map)
      _ -> map
    end
  end

  defp still_to_process(map) do
    map
    |> Enum.reduce_while(false, fn
      line, _acc ->
        Enum.reduce_while(line, false, fn
          {x, _}, _acc when x > 9 -> {:halt, true}
          {_, _}, _acc -> {:cont, false}
        end)
        |> case do
          true -> {:halt, true}
          false -> {:cont, false}
        end
    end)
  end

  defp check_flashes(map) do
    to_flash =
      map
      |> Enum.reduce({0, []}, fn
        e, {y, acc} ->
          new_flashes =
            Enum.reduce(e, {0, y, acc}, fn
              {count, _}, {x, y, acc} when count > 9 ->
                {x + 1, y, acc ++ [{x, y}]}

              _, {x, y, acc} ->
                {x + 1, y, acc}
            end)
            |> elem(2)

          {y + 1, new_flashes}
      end)

    to_flash
    |> elem(1)
    |> flash(map)
  end

  defp flash([], map), do: map
  defp flash([{x, y} | tail], map) when x < 0 or x > 9 or y < 0 or y > 9, do: flash(tail, map)

  defp flash([{x, y} | tail], map) do
    {map, new_points} =
      map
      |> get_point(x, y)
      |> case do
        {_, true} ->
          # IO.inspect("x: #{x} y: #{y} touched")
          {map, []}

        {count, false} when count > 9 ->
          {
            set_point(map, x, y, {0, true}),
            [
              {x - 1, y - 1},
              {x, y - 1},
              {x + 1, y - 1},
              {x - 1, y},
              {x + 1, y},
              {x - 1, y + 1},
              {x, y + 1},
              {x + 1, y + 1}
            ]
          }

        {count, false} ->
          # IO.inspect("x: #{x} y: #{y} inc")
          {set_point(map, x, y, {count + 1, false}), []}

        _ ->
          IO.inspect("x: #{x} y: #{y}")
      end

    flash(tail ++ new_points, map)
  end

  defp get_point(map, x, y) do
    map
    |> Enum.at(y)
    |> Enum.at(x)
  end

  defp set_point(map, x, y, value) do
    # IO.inspect("x: #{x} y: #{y} value: #{inspect(value)}", label: "SET")

    map
    |> List.update_at(y, fn line ->
      List.update_at(line, x, fn _e -> value end)
    end)
  end

  defp count_flashes(map) do
    map
    |> Enum.reduce(0, fn
      line, flashes ->
        Enum.reduce(line, flashes, fn
          {_, true}, flashes -> flashes + 1
          _, flashes -> flashes
        end)
    end)
  end

  def print_map(map) do
    map
    |> Enum.each(fn line ->
      line
      |> Enum.map(fn {n, _} -> Integer.to_string(n) end)
      |> Enum.join()
      |> IO.inspect()
    end)

    IO.inspect("")
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
