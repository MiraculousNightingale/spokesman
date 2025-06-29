defmodule Spokesman.UserMessages.UserMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_messages" do
    field :text, :string
    field :chat_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_message, attrs) do
    user_message
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
