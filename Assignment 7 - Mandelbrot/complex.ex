defmodule Cmplx do

  # Create a new complex number, r = real value, i = imaginary value
  def new(r, i) do
    {:cpx, r, i}
  end

  def add({:cpx, a1, a2}, {:cpx, b1, b2}) do
    {:cpx, a1 + b1, a2 + b2}
  end

  def sqr({:cpx, a1, a2}) do
    {:cpx, a1 * a1 - a2 * a2, 2 * a1 * a2}
  end

  def abs({:cpx, a1, a2}) do
    :math.sqrt(a1 * a1 + a2 * a2)
  end
end
