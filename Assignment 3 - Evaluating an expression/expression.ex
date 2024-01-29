defmodule Expression do

  @type literal() :: {:num, number()} | {:var, atom()} | {:q, number(), number()}

  @type expr() :: {:add, expr(), expr()}
    | {:sub, expr(), expr()}
    | {:mul, expr(), expr()}
    | {:div, expr(), expr()}
    | literal()

  @spec eval(expr(), Env) :: literal()

  def test_add do
    n1 = {:num, 5}
    n2 = {:q, 1, 2}
    e = {:add, n1, n2}
    env = [{:z, 15}, {:y, 10}, {:x, 5}]
    Expression.eval(e, env)
  end

  def test_sub do
    n1 = {:num, 5}
    n2 = {:q, 1, 2}
    e = {:sub, n1, n2}
    env = [{:z, 15}, {:y, 10}, {:x, 5}]
    Expression.eval(e, env)
  end

  def test_mul do
    n1 = {:num, 10}
    n2 = {:q, 1, 2}
    e = {:mul, n1, n2}
    env = [{:z, 15}, {:y, 10}, {:x, 5}]
    Expression.eval(e, env)
  end

  def test_div do
    e = {:div, {:q, 1, 2}, {:num, 2}}
    env = [{:y, 10}, {:x, 5}]
    Expression.eval(e, env)
  end

  def eval({:num, n}, _) do {:num, n} end
  def eval({:q, n, m}, _) do {:q, n, m} end
  def eval({:var, v}, env) do Env.lookup(env, v) end
  def eval({:add, n1, n2}, env) do
    add(eval(n1, env), eval(n2, env))
  end
  def eval({:sub, n1, n2}, env) do
    sub(eval(n1, env), eval(n2, env))
  end
  def eval({:mul, n1, n2}, env) do
    mul(eval(n1, env), eval(n2, env))
  end
  def eval({:div, n1, n2}, env) do
    divs(eval(n1, env), eval(n2, env))
  end

  ## GCD
  def reducegcd({:q, n, m}) do {:q, div(n, Integer.gcd(n, m)), div(m, Integer.gcd(n, m))} end

  ##  Arithmetics   ##
  def add({:num, n1}, {:num, n2}) do n1+n2 end
  def add({:num, n}, {:q, a, b}) do pprint(reducegcd({:q, ((n*b) + a), b})) end
  def add({:q, a, b}, {:num, n}) do pprint(reducegcd({:q, (n*b) + a, b})) end
  def add({:q, a, b}, {:q, c, d}) do pprint(reducegcd({:q, (a*d) + (b*c), b*d})) end

  def sub({:num, n1}, {:num, n2}) do n1-n2 end
  def sub({:num, n}, {:q, a, b}) do pprint(reducegcd({:q, (n*b) - a, b})) end
  def sub({:q, a, b}, {:num, n}) do pprint(reducegcd({:q, (n*b) - a, b})) end
  def sub({:q, a, b}, {:q, n, m}) do pprint(reducegcd({:q, (a*m) - (n*b), b*m})) end

  def mul({:num, n1}, {:num, n2}) do n1*n2 end
  def mul({:num, n}, {:q, a, b}) do pprint(reducegcd({:q, a*n, b})) end
  def mul({:q, a, b}, {:num, n}) do pprint(reducegcd({:q, a*n, b})) end
  def mul({:q, a, b}, {:q, n, m}) do pprint(reducegcd({:q, a*n, b*m})) end

  def divs({:num, _}, {:num, 0}) do :fail end
  def divs({:num, 0}, {:num, _}) do 0 end
  def divs({:num, a}, {:num, b}) do pprint(reducegcd({:q, a, b})) end
  def divs({:num, a}, {:q, c, d}) do pprint(reducegcd({:q, a*d, c})) end
  def divs({:q, a, b}, {:num, c}) do pprint(reducegcd({:q, a, b*c})) end
  def divs({:q, a, b}, {:q, c, d}) do pprint(reducegcd({:q, a*d, b*c})) end

  def pprint({:q, a, 1}) do a end
  def pprint({:q, a, b}) do "#{a}/#{b}" end

end

defmodule Env do
  def new(lst) do lst end

  def lookup([], _) do nil end
  def lookup([{key, value}|_], key) do value end
  def lookup([_|tail], key) do lookup(tail, key) end
end
