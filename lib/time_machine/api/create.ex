require IEx
defmodule TimeMachine.Api.Create do
  import Plug.Conn

  def init(opts) do
    Map.put(opts, :my_option, "Hello")
  end

  def call(conn, opts) do
    insert_time(conn.params, conn)
  end

  defp insert_time(%{ "time" => time, "counter" => counter, "name" => name }, conn) do
    { counter, _ } = Integer.parse(counter)
    TimeMachine.Clock.Server.add_clock(name, time, counter)
    send_resp(conn, 201, "Created")
  end

  defp insert_time(_, conn) do
    send_resp(conn, 422, "Unprocessable Entity")
  end
end
