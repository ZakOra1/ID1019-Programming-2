defmodule Deriv do
  # Assignment 1 in Programming 2, course ID1019 KTH
  # Zak Ora

  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), literal()}
  | {:ln, expr()}
  | {:sin, expr()}
  | {:cos, expr()}

  def test1() do
    e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}
        }
    d = deriv(e, :x)
    c = calc(d, :x, 5)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculcated: #{pprint(simplify(c))}\n")
    :ok
  end

  def test2() do
    e = {:add,
          {:exp, {:var, :x}, {:num, 3}},
          {:num, 4}
        }
    d = deriv(e, :x)
    c = calc(d, :x, 4)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculcated: #{pprint(simplify(c))}\n")
    :ok
  end

  def test3() do
    e = {:add,
          {:ln, {:add, {:mul, {:exp, {:var, :x}, {:num, 2}}, {:num, 3}}, {:num, 5}}},
          {:num, 4}
        }
    d = deriv(e, :x)
    c = calc(d, :x, 4)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculcated: #{pprint(simplify(c))}\n")
    :ok
  end

  def test4() do
    e = {:add,
          {:exp, {:exp, {:var, :x}, {:num, 2}}, {:num, -1}},
          {:num, 4}
        }
    d = deriv(e, :x)
    c = calc(d, :x, 4)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculcated: #{pprint(simplify(c))}\n")
    :ok
  end

  def test5() do
    e = {:add,
          {:sin, {:var, :x}},
          {:num, 4}
        }
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  # Derivative laws
  # Derivatives of sqrt, or for instance 1/x can be calculated using the derivative of an exponent
  #Derivation rules
  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end
  def deriv({:mul, e1, e2}, v) do
    {:add,
        {:mul, deriv(e1, v), e2},
        {:mul, e1, deriv(e2, v)}}
  end
  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
        {:mul, {:num, n}, {:exp, e, {:num, n-1}}},
        deriv(e,v)}
  end
  def deriv({:ln, e}, v) do
    {:mul,
        {:exp, e, {:num, -1}},
        deriv(e,v)}
  end
  def deriv({:sin, e}, v) do
    {:mul,
        {:cos, e}, deriv(e,v)}
  end
  def deriv({:cos, e}, v) do
    {:mul,
        {:mul,
            {:num, -1}, {:sin, e}},
        deriv(e,v)}
  end

    #Arithmetics
    def calc({:num, n}, _, _) do {:num, n} end
    def calc({:var, v}, v, n) do {:num, n} end
    def calc({:var, v}, _, _) do {:var, v} end
    def calc({:add, e1, e2}, v, n) do
      {:add, calc(e1, v, n), calc(e2, v, n)}
    end
    def calc({:mul, e1, e2}, v, n) do
      {:mul, calc(e1, v, n), calc(e2, v, n)}
    end
    def calc({:exp, e1, e2}, v, n) do
      {:exp, calc(e1, v, n), calc(e2, v, n)}
    end

  #Simplification in the terminal
  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end
  def simplify({:sin, e}) do
    simplify_sin(simplify(e))
  end
  def simplify({:cos, e}) do
    simplify_cos(simplify(e))
  end
  def simplify(e) do e end

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1, n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  def simplify_sin(0) do {:num, 0} end
  def simplify_sin(e) do {:sin, e} end

  def simplify_cos(0) do {:num, 1} end
  def simplify_cos(e) do {:cos, e} end

  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
  def pprint({:exp, e1, e2}) do "(#{pprint(e1)})^(#{pprint(e2)})" end
  def pprint({:ln, e}) do "ln(#{pprint(e)})" end
  def pprint({:sin, e}) do "sin(#{pprint(e)})" end
  def pprint({:cos, e}) do "cos(#{pprint(e)})" end

  # More simplification, derivations and calculations can be made
  # However this is enough for the assignment

end
