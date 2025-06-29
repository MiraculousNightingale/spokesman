defmodule Spokesman.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [])
    |> validate_required([])
  end
end
