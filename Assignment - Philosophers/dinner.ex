defmodule Dinner do
  def bench(hunger) do
    start_time = :erlang.monotonic_time()
    Dinner.start(hunger, self())
    receive do
      :done ->
        end_time = :erlang.monotonic_time()
        time = :erlang.convert_time_unit(end_time - start_time, :native, :millisecond)
        IO.puts "Time: #{time} for hunger #{hunger}"
    end
  end
  def start(hunger, parent), do: spawn(fn -> init(hunger, parent) end)
  def init(hunger, parent) do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    Philosopher.start(hunger, c1, c2, :arendt, ctrl, 5, 0)
    Philosopher.start(hunger, c2, c3, :hypatia, ctrl, 5, 0)
    Philosopher.start(hunger, c3, c4, :simone, ctrl, 5, 0)
    Philosopher.start(hunger, c4, c5, :elisabeth, ctrl, 5, 0)
    Philosopher.start(hunger, c5, c1, :ayn, ctrl, 5, 0)
    wait(5, [c1, c2, c3, c4, c5], parent)
  end

  def wait(0, chopsticks, parent) do
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
    send(parent, :done)
  end

  def wait(n, chopsticks, parent) do
    receive do
      :done -> wait(n - 1, chopsticks, parent)
      :abort -> Process.exit(self(), :kill)
    end
  end
end
