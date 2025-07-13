defmodule Spokesman.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do
    field :is_direct, :boolean

    has_many :user_messages, Spokesman.UserMessages.UserMessage

    has_many :chat_users, Spokesman.UserMessages.UserMessage
    has_many :users, through: [:chat_users, :user]

    belongs_to :last_user_message, Spokesman.UserMessages.UserMessage

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:last_user_message_id])
    |> validate_required([])
    |> assoc_constraint(:last_user_message)
  end
end
