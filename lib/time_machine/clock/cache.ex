defmodule TimeMachine.Clock.Cache do
  use GenServer
  import Ecto.Query, only: [from: 2]

  def start_link do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def add_clock(name, time, counter) do
    GenServer.cast(__MODULE__, {:add_clock, name, time, counter})
  end

  def show_clock(name) do
    GenServer.call(__MODULE__, {:show_clock, name})
  end

  ## GenServer
  #
  def handle_cast({:add_clock, name, time, counter}, _) do
    TimeMachine.Clock.Collection.update(name, time, counter)
    { :noreply, nil }
  end

  def handle_call({:show_clock, name}, _from, _) do
    time = name
          |> TimeMachine.Clock.Collection.find_by_name
          |> return_time
    { :reply, time, nil }
  end

  def return_time(nil) do
    DateTime.to_string(DateTime.utc_now)
  end

  def return_time(clock) do
    if clock.counter > 1 do
      TimeMachine.Clock.Collection.update(clock.name, clock.time, (clock.counter-1))
    else
      TimeMachine.Clock.Collection.delete_by_name(clock.name)
    end
    clock.time
  end
end
