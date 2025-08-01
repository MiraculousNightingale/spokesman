defmodule Spokesman.Repo.Migrations.CreateChatUsers do
  use Ecto.Migration

  def change do
    create table(:chat_users) do
      add :chat_id, references(:chats, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      add :role, :string, null: false, default: "user"

      timestamps(type: :utc_datetime)
    end

    create index(:chat_users, [:chat_id])
    create index(:chat_users, [:user_id])
  end
end
