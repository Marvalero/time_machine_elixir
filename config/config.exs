use Mix.Config

config :time_machine, TimeMachine.Clock.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "time_machine",
  username: "time_machine",
  password: "time_machine",
  hostname: "yomisma",
  port: "5432"


config :time_machine, ecto_repos: [TimeMachine.Clock.Repo]

