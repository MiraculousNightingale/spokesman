defmodule Spokesman.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do

      timestamps(type: :utc_datetime)
    end
  end
end
