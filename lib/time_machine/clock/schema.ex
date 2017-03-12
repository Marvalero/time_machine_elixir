defmodule TimeMachine.Clock.Schema do
  use Ecto.Schema

  schema "clocks" do
    timestamps
    field :time, :string
    field :counter, :integer
    field :name, :string
  end
end