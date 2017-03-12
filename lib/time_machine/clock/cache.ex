defmodule TimeMachine.Clock.Cache do
  use GenServer
  import Ecto.Query, only: [from: 2]

  def start_link([collection: collection]) do
    GenServer.start_link(__MODULE__, [collection: collection], name: __MODULE__)
  end

  def add_clock(name, time, counter) do
    GenServer.cast(__MODULE__, {:add_clock, name, time, counter})
  end

  def show_clock(name) do
    GenServer.call(__MODULE__, {:show_clock, name})
  end

  ## GenServer
  #
  def handle_cast({:add_clock, name, time, counter}, [collection: collection]) do
    collection.update(name, time, counter)
    { :noreply, [collection: collection] }
  end

  def handle_call({:show_clock, name}, _from, [collection: collection]) do
    time = name
          |> collection.find_by_name
          |> handle_clock(collection)
    { :reply, time, [collection: collection] }
  end

  def handle_clock(nil, _collection) do
    nil
  end

  def handle_clock(clock, collection) do
    if clock.counter > 1 do
      collection.update(clock.name, clock.time, (clock.counter-1))
    else
      collection.delete_by_name(clock.name)
    end
    clock.time
  end
end
