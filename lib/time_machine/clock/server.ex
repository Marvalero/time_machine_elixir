defmodule TimeMachine.Clock.Server do
  use GenServer

  def start_link do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def add_clock(name, time, count) do
    GenServer.cast(__MODULE__, {:add_clock, name, time, count})
  end

  def show do
    GenServer.call(__MODULE__, :show)
  end

  def show(name) do
    GenServer.call(__MODULE__, {:show, name})
  end

  #####      
  # GenServer implementation
  def handle_cast({:add_clock, name, time, count}, _) do
    TimeMachine.Clock.Cache.add_clock(name, time, count)
    { :noreply, nil }
  end

  def handle_call(:show, _from, _) do
    { :reply, DateTime.to_string(DateTime.utc_now), nil }
  end

  def handle_call({:show, name}, _from, _) do
    time = TimeMachine.Clock.Cache.show_clock(name)
    { :reply, time, nil }
  end
end
