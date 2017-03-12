defmodule TimeMachine.Clock do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(TimeMachine.Clock.Cache, cache_dependencies()),
      worker(TimeMachine.Clock.Server, server_dependencies()),
      worker(TimeMachine.Clock.Repo, []),
      worker(TimeMachine.Clock.Collection, collection_dependencies())
    ]

    opts = [strategy: :one_for_one, name: TimeMachine.Clock.Supervisor]
    supervise(children, opts)
  end

  defp server_dependencies do
    [[cache: TimeMachine.Clock.Cache]]
  end

  defp cache_dependencies do
    [[collection: TimeMachine.Clock.Collection]]
  end

  defp collection_dependencies do
    [[schema: TimeMachine.Clock.Schema, repo: TimeMachine.Clock.Repo]]
  end
end
