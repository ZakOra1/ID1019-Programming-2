defmodule Chopstick do
  def start do
    stick = spawn_link(fn -> available() end)
  end

  def available() do
    receive do
      {:request, from} ->
        send(from, :granted)
        gone()
      :quit -> :ok
    end
  end

  def quit(stick) do
    send(stick, :quit)
  end

  def gone() do
    receive do
      :return -> available()
      :quit -> :ok
    end
  end

  def request(stick) do
    send(stick, {:request, self()})
  end

  def granted(stick) do
    receive do
      :granted ->
        :ok
    after
      1000 -> :no
    end
  end

  def return(stick) do
    send(stick, :return)
  end
end
