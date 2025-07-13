defmodule Spokesman.UserMessages.UserMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_messages" do
    field :text, :string

    belongs_to :chat, Spokesman.Chats.Chat
    belongs_to :user, Spokesman.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_message, attrs) do
    user_message
    |> cast(attrs, [:text, :chat_id, :user_id])
    |> validate_required([:text, :chat_id, :user_id])
    |> assoc_constraint(:chat)
    |> assoc_constraint(:user)
  end
end
