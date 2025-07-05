defmodule Spokesman.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do
    has_many :user_messages, Spokesman.UserMessages.UserMessage

    has_many :chat_users, Spokesman.UserMessages.UserMessage
    has_many :users, through: [:chat_users, :user]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [])
    |> validate_required([])
  end
end
