defmodule TimeMachine.Clock.Repo.Migrations.AddClocks do
  use Ecto.Migration

  def change do
    create table(:clocks) do
      add :time,          :decimal
      add :counter,       :decimal
      add :name,          :decimal

      timestamps
    end
  end
end