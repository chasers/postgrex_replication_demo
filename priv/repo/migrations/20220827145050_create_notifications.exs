defmodule ReplicationDemo.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :message, :string

      timestamps()
    end
  end
end
