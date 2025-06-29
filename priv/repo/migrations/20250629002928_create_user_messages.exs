defmodule Spokesman.Repo.Migrations.CreateUserMessages do
  use Ecto.Migration

  def change do
    create table(:user_messages) do
      add :text, :text
      add :chat_id, references(:chats, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:user_messages, [:chat_id])
    create index(:user_messages, [:user_id])
  end
end
