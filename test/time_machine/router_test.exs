defmodule TimeMachine.RouterTest do
  use ExUnit.Case
  use Plug.Test
  doctest TimeMachine.Router

  alias TimeMachine.Router

  @opts Router.init([])

  test "returns time" do
    conn = conn(:get, "/time", "")
           |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns uploaded" do
    conn = conn(:post, "/time?name=MyClock&time=1234&counter=2")
           |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
  end

  test "returns 422 if parameters are wrong" do
    conn = conn(:post, "/time?perico=MyClock&lolo=1234")
           |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 422
  end

  test "returns 404" do
    conn = conn(:get, "/missing", "")
           |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end