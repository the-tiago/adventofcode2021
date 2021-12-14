defmodule AdventOfCode2021.Day10 do
  @moduledoc """
  Documentation for `AdventOfCode2021`.
  """

  @doc """
  https://adventofcode.com/2021/day/10

  ## Examples
    iex> AdventOfCode2021.Day10.part_1(['[({(<(())[]>[[{[]{<()<>>', '[(()[<>])]({[<{<<[]>>(', '{([(<{}[<>[]}>{[]{[(<()>', '(((({<>}<{<{<>}{[]{[]{}', '[[<[([]))<([[{}[[()]]]', '[{[{({}]{}}([{[{{{}}([]', '{<[[]]>}<{[{[{[]{()[[[]', '[<(<(<(<{}))><([]([]()', '<{([([[(<>()){}]>(<<{{', '<{([{{}}[<[[[<>{}]]]>[]]'])
    26397
  """
  def part_1(input) do
    input
    |> find_corrupted_lines()
    |> compute_syntax_errors()
  end

  defp compute_syntax_errors(errors) do
    errors
    |> Enum.reduce(0, fn
      {?), count}, acc -> 3 * count + acc
      {?], count}, acc -> 57 * count + acc
      {?}, count}, acc -> 1197 * count + acc
      {?>, count}, acc -> 25137 * count + acc
    end)
  end

  defp find_corrupted_lines(input) do
    Enum.reduce(input, %{}, fn line, acc ->
      case check_line(line, []) do
        {:corrupted, char} -> Map.update(acc, char, 1, &(&1 + 1))
        _ -> acc
      end
    end)
  end

  defp check_line([], stack), do: {:ok, stack}

  defp check_line([?) | line_tail], [?( | stack_tail]),
    do: check_line(line_tail, stack_tail)

  defp check_line([?] | line_tail], [?[ | stack_tail]),
    do: check_line(line_tail, stack_tail)

  defp check_line([?} | line_tail], [?{ | stack_tail]),
    do: check_line(line_tail, stack_tail)

  defp check_line([?> | line_tail], [?< | stack_tail]),
    do: check_line(line_tail, stack_tail)

  defp check_line([?( = char | line_tail], stack),
    do: check_line(line_tail, [char] ++ stack)

  defp check_line([?[ = char | line_tail], stack),
    do: check_line(line_tail, [char] ++ stack)

  defp check_line([?{ = char | line_tail], stack),
    do: check_line(line_tail, [char] ++ stack)

  defp check_line([?< = char | line_tail], stack),
    do: check_line(line_tail, [char] ++ stack)

  defp check_line([char | _line_tail], _stack), do: {:corrupted, char}

  @doc """
  https://adventofcode.com/2021/day/10

  ## Examples
    iex> AdventOfCode2021.Day10.part_2(['[({(<(())[]>[[{[]{<()<>>', '[(()[<>])]({[<{<<[]>>(', '{([(<{}[<>[]}>{[]{[(<()>', '(((({<>}<{<{<>}{[]{[]{}', '[[<[([]))<([[{}[[()]]]', '[{[{({}]{}}([{[{{{}}([]', '{<[[]]>}<{[{[{[]{()[[[]', '[<(<(<(<{}))><([]([]()', '<{([([[(<>()){}]>(<<{{', '<{([{{}}[<[[[<>{}]]]>[]]'])
    288957
  """
  def part_2(input) do
    scores =
      input
      |> find_incomplete_lines()
      |> compute_line_values()
      |> Enum.sort()

    scores
    |> Enum.at(div(length(scores) - 1, 2))
  end

  defp find_incomplete_lines(input) do
    Enum.reduce(input, [], fn line, acc ->
      case check_line(line, []) do
        {:ok, stack} -> acc ++ [stack]
        _ -> acc
      end
    end)
  end

  defp compute_line_values(stacks) do
    stacks
    |> Enum.map(fn stack ->
      compute_for_line(stack, 0)
    end)
  end

  defp compute_for_line([], acc), do: acc

  defp compute_for_line([char | line], acc) do
    compute_for_line(line, acc * 5 + get_char_value(char))
  end

  defp get_char_value(?(), do: 1
  defp get_char_value(?[), do: 2
  defp get_char_value(?{), do: 3
  defp get_char_value(?<), do: 4

  @doc """
  Parse the content of the input file for this day.
  Returns a list of lists of integers
  """
  def parse_input(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end
end
