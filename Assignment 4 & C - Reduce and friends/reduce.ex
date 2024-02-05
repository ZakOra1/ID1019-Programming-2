defmodule Reduce do
  require Integer

  # return the length of the list.
  @spec length([integer()]) :: integer()
  def length([_hd | []], acc) do acc end
  def length([_hd | tl], acc) do length(tl, acc + 1) end
  def length([hd | tl]) do length([hd | tl], 1) end


  # return a list of all even number.
  @spec even([integer()]) :: [integer()]
  def even([hd | []], acc) do
    if Integer.is_even(hd), do: acc ++ [hd], else: acc
  end
  def even([hd | tl], acc) do
    if Integer.is_even(hd) do
      even(tl, acc ++ [hd])
    else
      even(tl, acc)
    end
  end
  def even([hd | tl]), do: even([hd | tl], [])


  # return a list where each element of the given list has been incremented by a value.
  @spec inc([integer()], integer()) :: [integer()]
  def inc([hd | []], value, acc), do: acc ++ [hd + value]
  def inc([hd | tl], value, acc), do: inc(tl, value, acc ++ [hd + value])
  def inc([hd | tl], value), do: inc(tl, value, [hd + value])


  # return the sum of all values of the given list.
  @spec sum([integer()]) :: integer()
  def sum([hd | []], acc), do: acc + hd
  def sum([hd | tl], acc), do: sum(tl, acc + hd)
  def sum([hd | tl]), do: sum(tl, hd)


  # return a list where each element of the given list has been decremented by a value.
  @spec dec([integer()], integer()) :: [integer()]
  def dec([hd | []], value, acc), do: acc ++ [hd - value]
  def dec([hd | tl], value, acc), do: dec(tl, value, acc ++ [hd - value])
  def dec([hd | tl], value), do: dec(tl, value, [hd - value])


  #return a list where each element of the given list has been multiplied by a value.
  @spec mul([integer()], integer()) :: [integer()]
  def mul([hd | []], value, acc), do: acc ++ [hd * value]
  def mul([hd | tl], value, acc), do: mul(tl, value, acc ++ [hd * value])
  def mul([hd | tl], value), do: mul(tl, value, [hd * value])


  # return a list of all odd number.
  @spec odd([integer()]) :: [integer()]
  def odd([hd | []], acc) do
    if Integer.is_odd(hd), do: acc ++ [hd], else: acc
  end
  def odd([hd | tl], acc) do
    if Integer.is_odd(hd) do
      odd(tl, acc ++ [hd])
    else
      odd(tl, acc)
    end
  end
  def odd([hd | tl]), do: odd([hd | tl], [])


  # return a list with the result of taking the reminder of dividing the original by some integer.
  @spec rem([integer()], integer()) :: [integer()]
  def rem([hd | []], value, acc), do: acc ++ [Integer.mod(hd,value)]
  def rem([hd | tl], value, acc), do: rem(tl, value, acc ++ [Integer.mod(hd,value)])
  def rem([hd | tl], value) do
    if value == 0 do
      "Divison by 0 not allowed"
    else
      rem(tl, value, [Integer.mod(hd,value)])
    end
  end


  # return the product of all values of the given list (what is the product of all values of a an empty list?)
  @spec prod([integer()]) :: integer()
  def prod([hd | []], acc), do: acc*hd
  def prod([hd | tl], acc), do: prod(tl, acc*hd)
  def prod([hd | tl]), do: prod(tl, hd)
  def prod([]), do: 1


  # return a list of all numbers that are evenly divisible by some number.
  @spec divs([integer()], integer()) :: [integer()]
  def divs([], _), do: []
  def divs([hd | tl], value) do
    if Integer.mod(hd, value) == 0 do
      [hd | divs(tl, value)]
    else
      divs(tl, value)
    end
  end

end
