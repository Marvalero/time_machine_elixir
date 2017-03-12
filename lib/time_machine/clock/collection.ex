defmodule TimeMachine.Clock.Collection do
  use GenServer
  import Ecto.Query, only: [from: 2]

  def start_link do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def insert(name, time, counter) do
    GenServer.cast(__MODULE__, {:insert, name, time, counter})
  end

  def update(name, time, counter) do
    delete_by_name(name)
    insert(name, time, counter)
  end

  def delete_by_name(name) do
    GenServer.cast(__MODULE__, {:delete_by_name, name})
  end

  def find_by_name(name) do
    GenServer.call(__MODULE__, {:find_by_name, name})
  end

  ## GenServer
  #
  def handle_cast({:insert, name, time, counter}, _) do
    %TimeMachine.Clock.Schema{name: name, time: time, counter: counter}
    |> TimeMachine.Clock.Repo.insert
    { :noreply, nil }
  end

  def handle_cast({:delete_by_name, name}, _) do
    query = from s in TimeMachine.Clock.Schema, where: s.name == ^name
    query
    |> TimeMachine.Clock.Repo.all
    |> Enum.map(&TimeMachine.Clock.Repo.delete(&1))
    { :noreply, nil }
  end

  def handle_call({:find_by_name, name}, _from, _) do
    query = from s in TimeMachine.Clock.Schema, where: s.name == ^name
    time = query
           |> TimeMachine.Clock.Repo.all
           |> List.first

    { :reply, time, nil }
  end
end
