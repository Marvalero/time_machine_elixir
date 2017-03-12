
defmodule TimeMachine do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, TimeMachine.Router, [], [port: 4000]),
      worker(TimeMachine.Clock, [])
    ]

    opts = [strategy: :one_for_one, name: TimeMachine.Supervisor]
    Supervisor.start_link(children, opts)
  end
end