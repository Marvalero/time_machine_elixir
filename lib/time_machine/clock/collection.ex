defmodule TimeMachine.Clock.Collection do
  use GenServer
  import Ecto.Query, only: [from: 2]

  def start_link([schema: schema, repo: repo]) do
    GenServer.start_link(__MODULE__, [schema: schema, repo: repo], name: __MODULE__)
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
  def handle_cast({:insert, name, time, counter}, [schema: schema, repo: repo]) do
    %TimeMachine.Clock.Schema{name: name, time: time, counter: counter}
    |> repo.insert
    { :noreply, [schema: schema, repo: repo] }
  end

  def handle_cast({:delete_by_name, name}, [schema: schema, repo: repo]) do
    query = from s in schema, where: s.name == ^name
    query
    |> repo.all
    |> Enum.map(&repo.delete(&1))
    { :noreply, [schema: schema, repo: repo] }
  end

  def handle_call({:find_by_name, name}, _from, [schema: schema, repo: repo]) do
    query = from s in schema, where: s.name == ^name
    time = query
           |> repo.all
           |> List.first

    { :reply, time, [schema: schema, repo: repo] }
  end
end
