defmodule TimeMachine.Router do
  use Plug.Router

  plug Plug.Parsers, parsers: [:json],
                     pass:  ["text/*"],
                     json_decoder: Poison
  plug :match
  plug :dispatch

  get "/ping" do
    conn
    |> send_resp(200, "Pong!")
  end

  get "/time", to: TimeMachine.Api.Show
  get "/time/:name", to: TimeMachine.Api.Show
  post "/time", to: TimeMachine.Api.Create

  match _ do  
    conn
    |> send_resp(404, "Not Found")
    |> halt
  end

  def start_link do
    Plug.Adapters.Cowboy.http(Plugger.Router, [])
  end
end