defmodule TimeMachine.Api.Create do
  import Plug.Conn

  def init(opts) do
    Map.put(opts, :my_option, "Hello")
  end

  def call(conn, opts) do
    %{ "time" => time, "count" => count, "name" => name } = conn.params
    { count, _ } = Integer.parse(count)
    TimeMachine.Clock.Server.add_clock(name, time, count)
    send_resp(conn, 201, "Created")
  end
end
