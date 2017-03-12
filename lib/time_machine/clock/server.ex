defmodule TimeMachine.Clock.Server do
  use GenServer

  def start_link([cache: cache]) do
    GenServer.start_link(__MODULE__, [cache: cache], name: __MODULE__)
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
  def handle_cast({:add_clock, name, time, count}, [cache: cache]) do
    cache.add_clock(name, time, count)
    { :noreply, [cache: cache] }
  end

  def handle_call(:show, _from, [cache: cache]) do
    { :reply, DateTime.to_string(DateTime.utc_now), [cache: cache] }
  end

  def handle_call({:show, name}, _from, [cache: cache]) do
    time = cache.show_clock(name)
    { :reply, time, [cache: cache] }
  end
end
