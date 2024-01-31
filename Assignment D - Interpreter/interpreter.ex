defmodule Env do
  # return an empty environment
  def new() do [] end

  # return an environment where the binding of the variable id to the structure str has been added to the environment env.
  def add(id, str, env) do [{id, str} | env] end

  # return either {id, str}, if the variable id was bound, or nil
  def lookup(_, []) do nil end
  def lookup(id, [{id, str}|_]) do {id, str} end
  def lookup(id, [_|tail]) do lookup(id, tail) end

  # Returns an environment where all bindings for variables in the list ids have been removed
  def remove([], env), do: env
  def remove([id | rest], env) do
    filtered_env = Enum.filter(env, fn {var, _} -> var != id end)
    remove(rest, filtered_env)
  end

  def closure(keyss, env) do
    List.foldr(keyss, [], fn(key, acc) ->
      case acc do
        :error ->
          :error

        cls ->
          case lookup(key, env) do
            {key, value} ->
              [{key, value} | cls]

            nil ->
              :error
          end
      end
    end)
  end

  def args(pars, args, env) do
    List.zip([pars, args]) ++ env
  end

end

defmodule Eager do

  #######  Evaluate Expression  #######
  # If env is empty accept the atom
  def eval_expr({:atm, id}, _) do {:ok, id} end

  # If var exists in env return its value, otherwise error
  def eval_expr({:var, id}, env) do
    # Check if id exists in env
    case Env.lookup(id, env) do
      nil ->
        :error
      {_, str} ->
        {:ok, str}
    end
  end

  # Evaluate cons cell
  def eval_expr({:cons, head_expr, tail_expr}, env) do
    case eval_expr(head_expr, env) do
      :error ->
        :error
      {:ok, head} ->
        case eval_expr(tail_expr, env) do
          :error ->
            :error
          {:ok, tail} ->
            {:ok, {head, tail}}
        end
    end
  end

  # Evaluate case expression
  def eval_expr({:case, expr, cls}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, str} ->
        eval_cls(cls, str, env)
    end
  end

  # Evaluate lambda expression
  def eval_expr({:lambda, par, free, seq}, env) do
    case Env.closure(free, env) do
      :error ->
        :error
      closure ->
        {:ok, {:closure, par, seq, closure}}
    end
  end


  def eval_expr({:apply, expr, args}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, {:closure, par, seq, closure}} ->
        case eval_args(args, env) do
          :error ->
            :error
          {:ok, strs} ->
            env = Env.args(par, strs, closure)
            eval_seq(seq, env)
        end
    end
  end

  def eval_expr({:fun, id}, env) do
    {par, seq} = apply(Prgm, id, [])
    {:ok, {:closure, par, seq, Env.new()}}
  end

  def eval_args(args, env) do
    eval_args(args, env, [])
  end

  def eval_args([], _, strs) do {:ok, Enum.reverse(strs)}  end
  def eval_args([expr | exprs], env, strs) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, str} ->
        eval_args(exprs, env, [str|strs])
    end
  end



  #######  Pattern Matching  #######
  # Matching with the ignore/dont care
  def eval_match(:ignore, _, env) do
    {:ok, env}
  end

  # Matching an atom with the data structure (this does not take into consideration if
  # the atom in the pattern matches the data structure)
  def eval_match({:atm, id}, id, env) do
    {:ok, env}
  end

  # Matching the variable with the data structure,
  # if the variable is bound to other data return :fail,
  # otherwise return ok and add to env
  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil ->
        {:ok, Env.add(id, str, env)}  # Bind the variable to the matched value
      {_, ^str} ->
        {:ok, env}  # Variable is already bound to the same value, return unchanged environment
      {_, _} ->
        :fail  # Variable is bound to a different value, fail
    end
  end

  # Recurisevly go through cons cell
  def eval_match({:cons, hp, tp}, {hs, ts}, env) do
    case eval_match(hp, hs, env) do
      :fail ->
        :fail
      {:ok, env} ->
        eval_match(tp, ts, env)
    end
  end

  # And last but not least, if we can not match the pattern to the data structure we fail.
  def eval_match(_, _, _) do
    :fail
  end

  #######  Evaluate Sequence  #######
  # Remove bindings of existing variables
  def eval_scope(vars, env) do
    Env.remove(extract_vars(vars), env)
  end

  # Recursively traverses the pattern and extracts variables when encountered.
  def extract_vars(pattern) do
    case pattern do
      {:var, id} ->
        [id]
      {:cons, head, tail} ->
        extract_vars(head) ++ extract_vars(tail)
      _ ->
        []
    end
  end

  # Evaluate sequence if there's only one expression in it
  def eval_seq([exp], env) do
    eval_expr(exp, env)
  end

  # Pattern matching
  def eval_seq([{:match, pattern, expression} | rest], env) do
    case eval_expr(expression, env) do
      :error ->
        :error
      {:ok, value} ->
        env = eval_scope(pattern, env)

        case eval_match(pattern, value, env) do
          :fail ->
            :error
          {:ok, env} -> eval_seq(rest, env)
        end
    end
  end

  # Evaluate a sequence and return the result
  def eval(seq) do
    case eval_seq(seq, []) do
      {:ok, value} -> {:ok, value}
      _ -> :error
    end
  end

  #######  Evaluate Sequence  #######
  def eval_cls([], _, _) do
    :error
  end

  def eval_cls([{:clause, ptr, seq} | cls], str, env) do
    case eval_match(ptr, str, eval_scope(ptr, env)) do
      :fail ->
        eval_cls(cls, str, env)
      {:ok, env} ->
        eval_seq(seq, env)
    end
  end
end

defmodule Prgm do
  def append() do
    {[:x, :y],
      [{:case, {:var, :x},
        [{:clause, {:atm, []}, [{:var, :y}]},
          {:clause, {:cons, {:var, :hd}, {:var, :tl}},
            [{:cons,
              {:var, :hd},
                {:apply, {:fun, :append}, [{:var, :tl}, {:var, :y}]}}]}]}]}
  end
end
