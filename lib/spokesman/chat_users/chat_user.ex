defmodule Spokesman.ChatUsers.ChatUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat_users" do
    belongs_to :chat, Spokesman.Chats.Chat
    belongs_to :user, Spokesman.Users.User

    field :role, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat_user, attrs) do
    chat_user
    |> cast(attrs, [])
    |> validate_required([])
    |> validate_inclusion(:role, ["owner", "user", "admin", "moderator"])
  end
end
