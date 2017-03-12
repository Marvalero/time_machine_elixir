defmodule TimeMachine.Clock.Repo.Migrations.AddClocks do
  use Ecto.Migration

  def change do
    create table(:clocks) do
      add :time,          :string
      add :counter,       :integer
      add :name,          :string

      timestamps
    end
  end
end
