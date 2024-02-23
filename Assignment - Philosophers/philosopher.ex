defmodule Philosopher do

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

  def start(hunger, right_chopstick, left_chopstick, name, ctrl, strength, backoff) do
    philosopher = spawn_link(fn -> think(hunger, right_chopstick, left_chopstick, name, ctrl, strength, backoff) end)
  end


  def eat(0, right_chopstick, left_chopstick, name, ctrl, strength, backoff) do
    IO.puts "#{name} is done eating"
    send(ctrl, :done)
  end
  def eat(hunger, right_chopstick, left_chopstick, name, ctrl, strength, backoff) do
    #IO.puts "#{name} is eating"
    sleep(100)

    Chopstick.return(right_chopstick)
    #IO.puts "#{name} has returned the right chopstick"
    Chopstick.return(left_chopstick)
    #IO.puts "#{name} has returned the left chopstick"

    think(hunger-1, right_chopstick, left_chopstick, name, ctrl, strength, backoff)
  end

  # Philosophers think/dream for a while before they start eat
  def think(0, right_chopstick, left_chopstick, name, ctrl, strength, backoff) do
    eat(0, right_chopstick, left_chopstick, name, ctrl, strength, backoff)
  end
  def think(hunger, right_chopstick, left_chopstick, name, ctrl, strength, backoff) do
    #IO.puts "#{name} is thinking"
    sleep(100)
    waiting(hunger, right_chopstick, left_chopstick, name, ctrl, strength, backoff)
  end


  def waiting(hunger, right_chopstick, left_chopstick, name, ctrl, 0, backoff) do
    IO.puts "#{name} died."
    send(ctrl, :done)
  end
  def waiting(hunger, right_chopstick, left_chopstick, name, ctrl, strength, backoff) do
    # Randomly decide which chopstick to pick up first
    first_chopstick = if :random.uniform(2) == 1, do: right_chopstick, else: left_chopstick
    second_chopstick = if first_chopstick == right_chopstick, do: left_chopstick, else: right_chopstick

    Chopstick.request(first_chopstick)
    Chopstick.request(second_chopstick)

    state1 = Chopstick.granted(first_chopstick)
    state2 = Chopstick.granted(second_chopstick)

    state = {state1, state2}
    #IO.inspect(state)

    case state do
      {:no, :no} ->
        sleep(backoff)
        waiting(hunger, right_chopstick, left_chopstick, name, ctrl, strength-1, backoff+100)
        :no
      {:no, :ok} ->
        Chopstick.return(second_chopstick)
        sleep(backoff)
        waiting(hunger, right_chopstick, left_chopstick, name, ctrl, strength-1, backoff+100)
        :no
      {:ok, :no} ->
        Chopstick.return(first_chopstick)
        sleep(backoff)
        waiting(hunger, right_chopstick, left_chopstick, name, ctrl, strength-1, backoff+100)
        :no
      {:ok, :ok} ->
        #IO.puts "#{name} has both chopsticks"
        eat(hunger, right_chopstick, left_chopstick, name, ctrl, strength, 0)
    end
  end

end
