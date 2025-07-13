defmodule Spokesman.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :is_direct, :boolean, null: false, default: false

      timestamps(type: :utc_datetime)
    end
  end
end
