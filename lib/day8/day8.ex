defmodule AdventOfCode2021.Day8 do
  @moduledoc """
  Documentation for `AdventOfCode2021`.
  """

  @doc """
  https://adventofcode.com/2021/day/8

  ## Examples
    iex> AdventOfCode2021.Day8.part_1([%{signal: ["be", "cfbegad", "cbdgef", "fgaecd", "cgeb", "fdcge", "agebfd", "fecdb", "fabcd", "edb"], output: ["fdgacbe", "cefdb", "cefbgd", "gcbe"]}, %{signal: ["edbfga", "begcd", "cbg", "gc", "gcadebf", "fbgde", "acbgfd", "abcde", "gfcbed", "gfec"], output: ["fcgedb", "cgb", "dgebacf", "gc"]}, %{signal: ["fgaebd", "cg", "bdaec", "gdafb", "agbcfd", "gdcbef", "bgcad", "gfac", "gcb", "cdgabef"], output: ["cg", "cg", "fdcagb", "cbg"]}, %{signal: ["fbegcd", "cbd", "adcefb", "dageb", "afcb", "bc", "aefdc", "ecdab", "fgdeca", "fcdbega"], output: ["efabcd", "cedba", "gadfec", "cb"]}, %{signal: ["aecbfdg", "fbg", "gf", "bafeg", "dbefa", "fcge", "gcbea", "fcaegb", "dgceab", "fcbdga"], output: ["gecf", "egdcabf", "bgf", "bfgea"]}, %{signal: ["fgeab", "ca", "afcebg", "bdacfeg", "cfaedg", "gcfdb", "baec", "bfadeg", "bafgc", "acf"], output: ["gebdcfa", "ecba", "ca", "fadegcb"]}, %{signal: ["dbcfg", "fgd", "bdegcaf", "fgec", "aegbdf", "ecdfab", "fbedc", "dacgb", "gdcebf", "gf"], output: ["cefg", "dcbef", "fcge", "gbcadfe"]}, %{signal: ["bdfegc", "cbegaf", "gecbf", "dfcage", "bdacg", "ed", "bedf", "ced", "adcbefg", "gebcd"], output: ["ed", "bcgafe", "cdgba", "cbgef"]}, %{signal: ["egadfb", "cdbfeg", "cegd", "fecab", "cgb", "gbdefca", "cg", "fgcdab", "egfdb", "bfceg"], output: ["gbdfcae", "bgc", "cg", "cgb"]}, %{signal: ["gcafb", "gcf", "dcaebfg", "ecagb", "gf", "abcdeg", "gaef", "cafbge", "fdbac", "fegbdc"], output: ["fgae", "cfgab", "fg", "bagce"]}])
    26
  """
  def part_1(input) do
    input
    |> Enum.reduce(0, fn
      %{output: output}, acc ->
        Enum.reduce(output, acc, fn
          e, acc ->
            case String.length(e) do
              len when len == 2 or len == 3 or len == 4 or len == 7 -> acc + 1
              _ -> acc
            end
        end)
    end)
  end

  @doc """
  https://adventofcode.com/2021/day/8

  ## Examples
    iex> AdventOfCode2021.Day8.part_2([%{signal: ["be", "cfbegad", "cbdgef", "fgaecd", "cgeb", "fdcge", "agebfd", "fecdb", "fabcd", "edb"], output: ["fdgacbe", "cefdb", "cefbgd", "gcbe"]}, %{signal: ["edbfga", "begcd", "cbg", "gc", "gcadebf", "fbgde", "acbgfd", "abcde", "gfcbed", "gfec"], output: ["fcgedb", "cgb", "dgebacf", "gc"]}, %{signal: ["fgaebd", "cg", "bdaec", "gdafb", "agbcfd", "gdcbef", "bgcad", "gfac", "gcb", "cdgabef"], output: ["cg", "cg", "fdcagb", "cbg"]}, %{signal: ["fbegcd", "cbd", "adcefb", "dageb", "afcb", "bc", "aefdc", "ecdab", "fgdeca", "fcdbega"], output: ["efabcd", "cedba", "gadfec", "cb"]}, %{signal: ["aecbfdg", "fbg", "gf", "bafeg", "dbefa", "fcge", "gcbea", "fcaegb", "dgceab", "fcbdga"], output: ["gecf", "egdcabf", "bgf", "bfgea"]}, %{signal: ["fgeab", "ca", "afcebg", "bdacfeg", "cfaedg", "gcfdb", "baec", "bfadeg", "bafgc", "acf"], output: ["gebdcfa", "ecba", "ca", "fadegcb"]}, %{signal: ["dbcfg", "fgd", "bdegcaf", "fgec", "aegbdf", "ecdfab", "fbedc", "dacgb", "gdcebf", "gf"], output: ["cefg", "dcbef", "fcge", "gbcadfe"]}, %{signal: ["bdfegc", "cbegaf", "gecbf", "dfcage", "bdacg", "ed", "bedf", "ced", "adcbefg", "gebcd"], output: ["ed", "bcgafe", "cdgba", "cbgef"]}, %{signal: ["egadfb", "cdbfeg", "cegd", "fecab", "cgb", "gbdefca", "cg", "fgcdab", "egfdb", "bfceg"], output: ["gbdfcae", "bgc", "cg", "cgb"]}, %{signal: ["gcafb", "gcf", "dcaebfg", "ecagb", "gf", "abcdeg", "gaef", "cafbge", "fdbac", "fegbdc"], output: ["fgae", "cfgab", "fg", "bagce"]}])
    61229
  """
  def part_2(input) do
    input
    |> Enum.reduce(0, fn %{signal: signal, output: output}, acc ->
      acc +
        (signal
         |> decode_wires()
         |> get_real_values(output))
    end)
  end

  defp get_real_values(decode_table, output) do
    output
    |> Enum.reduce("", fn word, acc ->
      acc <> Map.get(decode_table, sort_letters(word))
    end)
    |> Integer.parse()
    |> elem(0)
  end

  defp decode_wires(signal) do
    word_map =
      signal
      |> Enum.reduce(%{}, fn
        word, acc -> Map.update(acc, map_word(word), [word], fn e -> e ++ [word] end)
      end)

    connections = %{
      a: :unknown,
      b: :unknown,
      c: :unknown,
      d: :unknown,
      e: :unknown,
      f: :unknown,
      g: :unknown
    }

    {word_map, _connections} =
      {word_map, connections}
      |> rule_1()
      |> rule_2()
      |> rule_3()
      |> rule_4()
      |> rule_5()
      |> rule_6()
      |> rule_7()

    word_map
    |> Enum.reduce(%{}, fn {digit, [word]}, acc ->
      Map.put(acc, sort_letters(word), to_ordinal(digit))
    end)
  end

  defp to_ordinal(:zero), do: "0"
  defp to_ordinal(:one), do: "1"
  defp to_ordinal(:two), do: "2"
  defp to_ordinal(:three), do: "3"
  defp to_ordinal(:four), do: "4"
  defp to_ordinal(:five), do: "5"
  defp to_ordinal(:six), do: "6"
  defp to_ordinal(:seven), do: "7"
  defp to_ordinal(:eight), do: "8"
  defp to_ordinal(:nine), do: "9"

  # 7 minus 1 = top led
  defp rule_1({word_map, connections}) do
    [one] = Map.get(word_map, :one)
    [seven] = Map.get(word_map, :seven)
    [letter] = diff(seven, one)

    {word_map, Map.put(connections, :a, String.to_atom(letter))}
  end

  # find 3
  defp rule_2({word_map, connections}) do
    [a, b, c] = Map.get(word_map, :two_or_three_or_five)

    {three, two_or_five} =
      case diff(a, b) do
        lst when length(lst) == 2 ->
          {c, [a, b]}

        _ ->
          case diff(a, c) do
            lst when length(lst) == 2 -> {b, [a, c]}
            _ -> {a, [b, c]}
          end
      end

    {
      word_map
      |> Map.put(:three, [three])
      |> Map.put(:two_or_five, two_or_five)
      |> Map.delete(:two_or_three_or_five),
      connections
    }
  end

  # four minus three = upper left led (b)
  defp rule_3({word_map, connections}) do
    [four] = Map.get(word_map, :four)
    [three] = Map.get(word_map, :three)
    [letter] = diff(four, three)

    {word_map, Map.put(connections, :b, String.to_atom(letter))}
  end

  # eight minus three minus b = lower left led (e)
  defp rule_4({word_map, connections}) do
    [eight] = Map.get(word_map, :eight)
    [three] = Map.get(word_map, :three)

    [letter] =
      diff(eight, three) --
        [Atom.to_string(Map.get(connections, :b))]

    {word_map, Map.put(connections, :e, String.to_atom(letter))}
  end

  # find 5 (have b) and 2 (doesn't have b)
  defp rule_5({word_map, connections}) do
    [a, b] = Map.get(word_map, :two_or_five)

    {two, five} =
      case String.codepoints(a) -- [Atom.to_string(Map.get(connections, :b))] do
        lst when length(lst) == 5 -> {a, b}
        _ -> {b, a}
      end

    {
      word_map
      |> Map.put(:two, [two])
      |> Map.put(:five, [five])
      |> Map.delete(:two_or_five),
      connections
    }
  end

  # find 9 (eight minus e = nine)
  defp rule_6({word_map, connections}) do
    [a, b, c] =
      Map.get(word_map, :zero_or_six_or_nine)
      |> Enum.map(&sort_letters(&1))

    [eight] =
      Map.get(word_map, :eight)
      |> Enum.map(&sort_letters(&1))

    e = [Atom.to_string(Map.get(connections, :e))]

    {nine, zero_or_six} =
      (String.codepoints(eight) -- e)
      |> Enum.reduce("", &(&2 <> &1))
      |> case do
        ^a -> {a, [b, c]}
        ^b -> {b, [a, c]}
        ^c -> {c, [a, b]}
      end

    {
      word_map
      |> Map.put(:nine, [nine])
      |> Map.put(:zero_or_six, zero_or_six)
      |> Map.delete(:zero_or_six_or_nine),
      connections
    }
  end

  defp sort_letters(word) do
    word
    |> String.codepoints()
    |> Enum.sort()
    |> Enum.join()
  end

  # find 6 (six minus one = 1 segment) and 0 (zero minus 1 = 0 segments)
  defp rule_7({word_map, connections}) do
    [a, b] = Map.get(word_map, :zero_or_six)
    [one] = Map.get(word_map, :one)

    {zero, six} =
      case diff(a, one) do
        lst when length(lst) == 4 -> {a, b}
        _ -> {b, a}
      end

    {
      word_map
      |> Map.put(:zero, [zero])
      |> Map.put(:six, [six])
      |> Map.delete(:zero_or_six),
      connections
    }
  end

  defp diff(first, second) do
    String.codepoints(first) -- String.codepoints(second)
  end

  defp map_word(word) do
    case String.length(word) do
      len when len == 2 -> :one
      len when len == 3 -> :seven
      len when len == 4 -> :four
      len when len == 5 -> :two_or_three_or_five
      len when len == 6 -> :zero_or_six_or_nine
      len when len == 7 -> :eight
      _ -> :error
    end
  end

  @doc """
  Parse the content of the input file for this day.
  Returns a list of integers
  """
  def parse_input(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [signal | [output | []]] = String.split(line, "|", trim: true)

    %{
      signal: String.split(signal, " ", trim: true),
      output: String.split(output, " ", trim: true)
    }
  end
end
