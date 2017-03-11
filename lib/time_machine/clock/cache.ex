require IEx
defmodule TimeMachine.Clock.Cache do
  use GenServer

  def start_link do
    GenServer.start(TimeMachine.Clock.Cache, %{}, name: TimeMachine.Clock.Cache)
  end

  def add_clock(name, time, count) do
    GenServer.cast(TimeMachine.Clock.Cache, {:add_clock, name, time, count})
  end

  def show_clock(name) do
    GenServer.call(TimeMachine.Clock.Cache, {:show_clock, name})
  end

  def handle_cast({:add_clock, name, time, count}, clocks_list) do
    { :noreply, Map.put(clocks_list, name, {time, count}) }
  end

  def handle_call({:show_clock, name}, _from, clocks_list) do
    { time, clocks_list } = clocks_list
                            |> Map.get(name)
                            |> return_time(name, clocks_list)

    { :reply, time, clocks_list }
  end

  def return_time(nil, _name, clocks_list) do
    { DateTime.to_string(DateTime.utc_now), clocks_list }
  end

  def return_time({time, count}, name, clocks_list) do
    new_list = (count > 1 && Map.put(clocks_list, name, {time, count-1})) || Map.delete(clocks_list, name) 
    { time, new_list }
  end
end
