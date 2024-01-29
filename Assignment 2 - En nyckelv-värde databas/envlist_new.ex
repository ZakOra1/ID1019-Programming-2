defmodule EnvList do

  #return an empty map
  def new() do [] end

  def add([], key, value) do [{key, value}] end   #If the given map is empty
  def add([{key,_}|tail], key, value) do [{key,value}|tail] end #If there already is an association of the key, the value is changed
  def add([head|tail], key, value) do [head|add(tail, key, value)] end    #Recursively scroll through map and add key-value

  def lookup([], _) do nil end                            #If the map is empty or key does not exist
  def lookup([{key, value}|_], key) do {key, value} end   #If the associated key is found
  def lookup([_|tail], key) do lookup(tail, key) end      #Recursively look for key

  #returns a map where the association of the key has been removed
  def remove([], _) do nil end
  def remove([{key, _}|tail], key) do tail end
  def remove([head|tail], key) do [head|remove(tail, key)] end


  def bench(n) do
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]

    :io.format("# benchmark with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])

    Enum.each(ls, fn (i) ->
      {i, tla, tll, tlr} = bench(i, n)

      :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla/n, tll/n, tlr/n])
    end)
  end

  def bench(i, n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)
    list = Enum.reduce(seq, EnvList.new(), fn(e, list) ->
      EnvList.add(list, e, :foo)
      end)
    seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)

    {add, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
        EnvList.add(list, e, :foo)
        end)
      end)

    {lookup, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
        EnvList.lookup(list, e)
        end)
      end)

    {remove, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
        EnvList.remove(list, e)
        end)
      end)

    {i, add, lookup, remove}
  end


end
