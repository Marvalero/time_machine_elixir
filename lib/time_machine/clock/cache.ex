defmodule TimeMachine.Clock.Cache do
  use GenServer
  import Ecto.Query, only: [from: 2]

  def start_link do
    GenServer.start(TimeMachine.Clock.Cache, %{}, name: TimeMachine.Clock.Cache)
  end

  def add_clock(name, time, counter) do
    GenServer.cast(TimeMachine.Clock.Cache, {:add_clock, name, time, counter})
  end

  def show_clock(name) do
    GenServer.call(TimeMachine.Clock.Cache, {:show_clock, name})
  end

  def handle_cast({:add_clock, name, time, counter}, _) do
    query = from s in TimeMachine.Clock.Schema, where: s.name == ^name
    query
    |> TimeMachine.Clock.Repo.all
    |> Enum.map(&TimeMachine.Clock.Repo.delete(&1))

    %TimeMachine.Clock.Schema{name: name, time: time, counter: counter}
    |> TimeMachine.Clock.Repo.insert
    { :noreply, nil }
  end

  def handle_call({:show_clock, name}, _from, _) do
    query = from s in TimeMachine.Clock.Schema, where: s.name == ^name
    time = query
           |> TimeMachine.Clock.Repo.all
           |> List.first
           |> TimeMachine.Clock.Cache.return_time

    { :reply, time, nil }
  end

  def return_time(nil) do
    DateTime.to_string(DateTime.utc_now)
  end

  def return_time(clock) do
    TimeMachine.Clock.Repo.delete(clock)
    if clock.counter > 1 do
      %TimeMachine.Clock.Schema{name: clock.name, time: clock.time, counter: (clock.counter-1)}
      |> TimeMachine.Clock.Repo.insert
    end
    clock.time
  end
end
