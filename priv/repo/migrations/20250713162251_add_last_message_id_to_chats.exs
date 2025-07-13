defmodule Spokesman.Repo.Migrations.AddLastMessageIdToChats do
  use Ecto.Migration

  def change do
    alter table(:chats) do
      add :last_user_message_id, references(:user_messages, on_delete: :nothing)
    end
  end
end
