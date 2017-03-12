defmodule TimeMachine.Clock do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(TimeMachine.Clock.Cache, []),
      worker(TimeMachine.Clock.Server, server_dependencies()),
      worker(TimeMachine.Clock.Repo, []),
      worker(TimeMachine.Clock.Collection, [])
    ]

    opts = [strategy: :one_for_one, name: TimeMachine.Clock.Supervisor]
    supervise(children, opts)
  end

  defp server_dependencies do
    [[cache: TimeMachine.Clock.Cache]]
  end
end