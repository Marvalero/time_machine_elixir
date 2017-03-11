# TimeMachine

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `time_machine` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:time_machine, "~> 0.1.0"}]
    end
    ```

  2. Ensure `time_machine` is started before your application:

    ```elixir
    def application do
      [applications: [:time_machine]]
    end
    ```

# Ecto

Run migrations:
```
mix do ecto.create, ecto.migrate
```

Create a new migration:
```
mix ecto.gen.migration new_migration
```

Run docker and check database
```
$ docker-compose up
$ docker exec -it timemachine_postgres_1 psql
> CREATE USER time_machine WITH CREATEDB PASSWORD 'time_machine';
> \l #List databases
> \connect time_machine
> \dt # List tables
```