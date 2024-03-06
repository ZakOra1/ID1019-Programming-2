defmodule Huffman do

  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} -> list
      list -> list
    end
  end

  def test do
    #decode = decode_table(tree)

    sample = read("kallocain.txt")
    text = read("kallocain.txt")
    tree = tree(sample)
    IO.puts("Sample complete")
    encode = encode_table(tree)
    IO.puts("Encode table complete")
    seq = encode(text, encode)
    IO.puts("Encode complete")
    #decode(seq, encode)

    {:ok, file} = File.open("output.txt", [:write, {:encoding, :utf8}])
    IO.write(file, List.to_string(decode(seq, encode)))
    :ok = File.close(file)

    IO.puts("Decode complete")
  end


  # Create a Huffman tree given a sample text
  def tree(sample) do
    freq_sorted = Enum.frequencies(sample)
          |> Enum.sort(fn {_, a}, {_, b} -> a < b end)
    huffman_tree(freq_sorted)
  end


  ############################
  #####      Encode      #####
  ############################

  # Create encode table
  def encode_table(tree) do
    depth_first_traversal(tree, [])
  end

  def depth_first_traversal({left, right}, acc) do
    depth_first_traversal(left, acc ++ [0]) ++ depth_first_traversal(right, acc ++ [1])
  end
  def depth_first_traversal(leaf, acc) do
    [{leaf, acc}]
  end

  # Encode text
  def encode([], _table, acc), do: List.flatten(acc)
  def encode([c1 | tail], table, acc) do
    # Encode the text using the mapping in the table, return a sequence of bits
    {_c1, path} = Enum.find(table, fn {c2, _} -> c1 == c2 end)
    IO.puts("Path: ")
    IO.inspect(path)
    acc = acc ++ [path]
    encode(tail, table, acc)
  end
  def encode(text, table) do
    encode(text, table, [])
  end



  ############################
  #####      Decode      #####
  ############################

  #def decode_table(tree) do
  #  # Create an decoding table containing the mapping from codes to characters given a Huffman tree
  #end

  def decode([], _) do
    []
  end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end
  def decode_char(seq, n, table) do
    {path, rest} = Enum.split(seq, n)
    case List.keyfind(table, path, 1) do
      {char, _} ->
        IO.puts("Found: #{char}")
        {char, rest}
      nil ->
        decode_char(seq, n+1, table)
    end
  end



  ############################
  #####   Huffman Tree   #####
  ############################

  def huffman_tree([{tree, _}]), do: tree
  def huffman_tree([{a, af}, {b, bf} | rest]) do
    huffman_tree(insert({{a, b}, af + bf}, rest))
  end

  def insert({a, af}, []), do: [{a, af}]
  def insert({a, af}, [{b, bf} | rest]) when af < bf do
    [{a, af}, {b, bf} | rest]
  end
  def insert({a, af}, [{b, bf} | rest]) do
    [{b, bf} | insert({a, af}, rest)]
  end

end
