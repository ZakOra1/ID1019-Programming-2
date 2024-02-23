defmodule Philosopher do

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

  def start(hunger, right_chopstick, left_chopstick, name, ctrl, strength) do
    philosopher = spawn_link(fn -> think(hunger, right_chopstick, left_chopstick, name, ctrl, strength) end)
  end


  def eat(0, right_chopstick, left_chopstick, name, ctrl, strength) do
    IO.puts "#{name} is done eating"
    send(ctrl, :done)
  end
  def eat(hunger, right_chopstick, left_chopstick, name, ctrl, strength) do
    #IO.puts "#{name} is eating"
    sleep(1000)

    Chopstick.return(right_chopstick)
    #IO.puts "#{name} has returned the right chopstick"
    Chopstick.return(left_chopstick)
    #IO.puts "#{name} has returned the left chopstick"

    think(hunger-1, right_chopstick, left_chopstick, name, ctrl, strength)
  end

  # Philosophers think/dream for a while before they start eat
  def think(0, right_chopstick, left_chopstick, name, ctrl, strength) do
    eat(0, right_chopstick, left_chopstick, name, ctrl, strength)
  end
  def think(hunger, right_chopstick, left_chopstick, name, ctrl, strength) do
    #IO.puts "#{name} is thinking"
    sleep(1000)
    waiting(hunger, right_chopstick, left_chopstick, name, ctrl, strength)
  end


  def waiting(hunger, right_chopstick, left_chopstick, name, ctrl, 0) do
    IO.puts "#{name} died."
    send(ctrl, :done)
  end
  def waiting(hunger, right_chopstick, left_chopstick, name, ctrl, strength) do
    Chopstick.request(right_chopstick)
    Chopstick.request(left_chopstick)

    state1 = Chopstick.granted(right_chopstick)
    state2 = Chopstick.granted(left_chopstick)

    state = {state1, state2}
    #IO.inspect(state)

    case state do
      {:no, :no} ->
        waiting(hunger, right_chopstick, left_chopstick, name, ctrl, strength-1)
        :no
      {:no, :ok} ->
        Chopstick.return(left_chopstick)
        waiting(hunger, right_chopstick, left_chopstick, name, ctrl, strength-1)
        :no
      {:ok, :no} ->
        Chopstick.return(right_chopstick)
        waiting(hunger, right_chopstick, left_chopstick, name, ctrl, strength-1)
        :no
      {:ok, :ok} ->
        #IO.puts "#{name} has both chopsticks"
        eat(hunger, right_chopstick, left_chopstick, name, ctrl, strength)
    end
  end

end
