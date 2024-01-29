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
