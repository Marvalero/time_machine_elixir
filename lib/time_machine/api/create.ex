require IEx
defmodule TimeMachine.Api.Create do
  import Plug.Conn

  def init(opts) do
    Map.put(opts, :my_option, "Hello")
  end

  def call(conn, opts) do
    %{ "time" => time, "counter" => counter, "name" => name } = conn.params
    { counter, _ } = Integer.parse(counter)
    TimeMachine.Clock.Server.add_clock(name, time, counter)
    send_resp(conn, 201, "Created")
  end
end
