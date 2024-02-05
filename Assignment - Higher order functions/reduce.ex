defmodule Reduce do
  @type a() :: any()
  @type b() :: any()

  @spec sum_of_squares_less_than_n([integer()], integer()) :: integer()
  def sum_of_squares_less_than_n(list, n) do
    list
    |> filter(&(&1 < n))
    |> map(&(&1 * &1))
    |> sum()
  end

  @spec length([a()]) :: integer()
  def length(list), do: reduce(list, 0, fn _elem, acc -> acc + 1 end)

  @spec even([integer()]) :: [integer()]
  def even(list), do: filter(list, &is_even/1)

  @spec is_even(integer()) :: boolean()
  defp is_even(n), do: rem(n, 2) == 0

  @spec inc([integer()], integer()) :: [integer()]
  def inc(list, value), do: map(list, &(&1 + value))

  @spec sum([integer()]) :: integer()
  def sum(list), do: reduce(list, 0, &Kernel.+/2)

  @spec dec([integer()], integer()) :: [integer()]
  def dec(list, value), do: map(list, &(&1 - value))

  @spec mul([integer()], integer()) :: [integer()]
  def mul(list, value), do: map(list, &(&1 * value))

  @spec odd([integer()]) :: [integer()]
  def odd(list), do: filter(list, &is_odd/1)

  @spec is_odd(integer()) :: boolean()
  defp is_odd(n), do: rem(n, 2) != 0

  @spec my_rem([integer()], integer()) :: [integer()]
  def my_rem(list, value), do: map(list, fn number -> rem(number, value) end)

  @spec prod([integer()]) :: integer()
  def prod(list), do: reduce(list, 1, &Kernel.*/2)

  @spec divs([integer()], integer()) :: [integer()]
  def divs(list, value), do: filter(list, fn x -> rem(x, value) == 0 end)

  @spec map([a()], (a() -> b())) :: [a()]
  def map([], _func), do: []
  def map([head | tail], func), do: [func.(head) | map(tail, func)]

  @spec reduce([a()], b(), (a(), b() -> b())) :: b()
  def reduce([], acc, _func), do: acc
  def reduce([hd | tl], acc, func), do: reduce(tl, func.(hd, acc), func)

  @spec filter([a()], (a() -> boolean())) :: [a()]
  def filter([], _func), do: []
  def filter([head | tail], func) do
    if func.(head) do
      [head | filter(tail, func)]
    else
      filter(tail, func)
    end
  end
end
