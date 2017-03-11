
defmodule TimeMachine.Api.Show do
  import Plug.Conn

  def init(opts) do
    Map.put(opts, :my_option, "Hello")
  end

  def call(%Plug.Conn{request_path: "/time/" <> name} = conn, opts) do
    send_resp(conn, 200, TimeMachine.Clock.Server.show(name))
  end

  def call(conn, opts) do
    send_resp(conn, 200, TimeMachine.Clock.Server.show)
  end
end
