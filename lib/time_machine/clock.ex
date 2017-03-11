defmodule TimeMachine.Clock do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      worker(TimeMachine.Clock.Cache, []),
      worker(TimeMachine.Clock.Server, [])
    ]

    opts = [strategy: :one_for_one, name: TimeMachine.Clock.Supervisor]
    supervise(children, opts)
  end
end