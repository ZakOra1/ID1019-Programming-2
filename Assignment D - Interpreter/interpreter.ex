defmodule Env do
  # return an empty environment
  def new() do [] end

  # return an environment where the binding of the variable id to the structure str has been added to the environment env.
  def add(id, str, env) do [{id, str} | env] end

  # return either {id, str}, if the variable id was bound, or nil
  def lookup(_, []) do [] end
  def lookup(id, [{id, str}|_]) do {id, str} end
  def lookup(id, [_|tail]) do lookup(id, tail) end

  # Returns an environment where all bindings for variables in the list ids have been removed
  def remove([], env), do: env
  def remove([id | rest], env) do
    filtered_env = Enum.filter(env, fn {var, _} -> var != id end)
    remove(rest, filtered_env)
  end

end

defmodule Eager do
  # If env is empty accept the atom
  def eval_expr({:atm, id}, []) do {:ok, id} end

  # If atom does not exist in env accept it, otherwise error
  def eval_expr({:atm, id}, env) do
    # iterate through env to check if id exists
    case Env.lookup(id, env) do
      [] ->
        {:ok, id}
      {id,_} ->
        :error
    end
  end

  # If var exists in env return its value, otherwise error
  def eval_expr({:var, id}, env) do
    # Check if id exists in env
    case Env.lookup(id, env) do
      [] ->
        :error
      {_, str} ->
        {:ok, str}
    end
  end

  # if head and tail exists in env return ok
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

end
