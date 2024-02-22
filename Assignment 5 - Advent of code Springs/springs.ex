  defmodule Springs do

    def parse_description(input) do
      input
      |> String.split(" ")
      |> Enum.reject(&String.trim(&1) == "")  # Remove empty rows
      |> Enum.chunk_every(2)  # Group every 2 elements into a tuple (status, sequence)
      |> Enum.map(&parse_row/1)
    end

    defp parse_row(row) do
      [status, sequence] = row
      {parse_status(status), parse_sequence(sequence)}
    end

    defp parse_status(status) do
      list = String.to_charlist(status)
    end

    defp parse_sequence(sequence) do
      sequence
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
    end

    defp generate_permutations_for_status({status, sequence}) do
      statuses = generate_status_permutations(status)
      Enum.map(statuses, fn st -> {st, sequence} end)
    end

    defp generate_status_permutations(status) do
      generate_permutations(status)
    end

    defp generate_permutations(list) do
      permute(list, [])
    end

    defp permute([], acc), do: [acc]
    defp permute([char | rest], acc) do
      case char do
        '?' ->
          acc |> Enum.flat_map(&permute(rest, &1))
        _ ->
          permute(rest, acc)
      end
    end

    # Input of parsed description, output list of possible solutions per row
    #@spec solutions(list()) :: list()

    #def solutions([], acc), do: acc
    #def solutions([hd | tl], acc) do
    #  #acc ++ [count_valid_perm(row_permutations(hd))]
    #  perms = row_permutations(hd)
    #  IO.inspect(perms)
    #  #counter = count_valid_perm(perms)
    #  #IO.inspect(counter)
    #  #acc ++ counter
    #  solutions(tl, acc)
    #end
    #def solutions(parsed_desc), do: solutions(parsed_desc, [])

  end
