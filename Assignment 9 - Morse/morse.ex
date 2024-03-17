  defmodule Morse do

    def text1(), do: '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ...'

    def text2(), do: '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .----'

    def test() do
      IO.inspect(decode(text1()))
      IO.inspect(decode(text2()))
      IO.puts("zak ora = #{encode('zak ora')}")
    end

    # Recurisvly decode all characters
    def decode(singal) do
      decode(singal, tree())
    end
    def decode(signal, tree) do
      case decode_char(signal, tree) do
        :error ->
          IO.puts("Error: ")
          IO.inspect(signal)
          {:error, signal}
        {char, []} ->
          [char]
        {char, rest} ->
          [char | decode(rest, tree)]
      end
    end

    # Decode the signal using the tree
    def decode_char([], {:node, char, _, _}), do: {char, []}
    def decode_char([?\s | rest], {:node, char, _, _}), do: {char, rest}
    def decode_char([?\s | rest], {:node, :na, _, _}), do: decode_char(rest, tree())
    def decode_char([?- | rest], {:node, _, long, _}), do: decode_char(rest, long)
    def decode_char([?. | rest], {:node, _, _, short}), do: decode_char(rest, short)


    def encode(text) do
      tree = tree()
      table = build_map(tree)
      text
      |> Enum.map(fn char -> Map.get(table, char) end)
      |> Enum.join(" ")
    end


    defp build_map(tree) do
      build_map(Map.new(), tree, [])
    end
    defp build_map(map, node, path) do
      case node do
        {:node, char, long, short} ->
          new_map = Map.put(map, char, Enum.reverse(path))
          new_map
          |> build_map(long, ['-' | path])
          |> build_map(short, ['.' | path])
        {:node, :na, long, short} ->
          map
          |> build_map(long, ['-' | path])
          |> build_map(short, ['.' | path])
        nil ->
          map
      end
    end

    # {:node, character, long, short}
    # {:node, :na, long, short} = Continute down the tree
    # {:node, character, nil, nil} = End of the tree, return path

    defp tree do
      {:node, :na,
        {:node, 116,
          {:node, 109,
            {:node, 111,
              {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
              {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
            {:node, 103,
              {:node, 113, nil, nil},
              {:node, 122,
                {:node, :na, {:node, 44, nil, nil}, nil},
                {:node, 55, nil, nil}}}},
          {:node, 110,
            {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
            {:node, 100,
              {:node, 120, nil, nil},
              {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
        {:node, 101,
          {:node, 97,
            {:node, 119,
              {:node, 106,
                {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
                nil},
              {:node, 112,
                {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
                nil}},
            {:node, 114,
              {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
              {:node, 108, nil, nil}}},
          {:node, 105,
            {:node, 117,
              {:node, 32,
                {:node, 50, nil, nil},
                {:node, :na, nil, {:node, 63, nil, nil}}},
              {:node, 102, nil, nil}},
            {:node, 115,
              {:node, 118, {:node, 51, nil, nil}, nil},
              {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
    end

  end
