defmodule TimeMachine.Api.ShowTets do
  use ExUnit.Case
  use Plug.Test
  doctest TimeMachine.Router

  alias TimeMachine.Router

  @opts Router.init([])

  test "returns 200 when GET /time" do
    conn = conn(:get, "/time", "")
           |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns correct body when GET /time" do
    conn = conn(:get, "/time", "")
           |> Router.call(@opts)

    assert Regex.run(~r{\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d}, conn.resp_body)
  end

  test "returns fake time clock created" do
    conn = conn(:post, "/time?name=myclock&time=1234&counter=1")
           |> Router.call(@opts)
    assert conn.status == 201

    conn = conn(:get, "/time/myclock")
           |> Router.call(@opts)
    assert conn.resp_body == "1234"

    conn = conn(:get, "/time/myclock")
           |> Router.call(@opts)
    assert Regex.run(~r{\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d}, conn.resp_body)
  end


  test "returns 404 when GET /invented_url" do
    conn = conn(:get, "/missing", "")
           |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end