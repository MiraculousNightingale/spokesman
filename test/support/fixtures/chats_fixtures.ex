defmodule Spokesman.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Spokesman.Chats` context.
  """

  @doc """
  Generate a chat.
  """
  def chat_fixture(attrs \\ %{}) do
    {:ok, chat} =
      attrs
      |> Enum.into(%{

      })
      |> Spokesman.Chats.create_chat()

    chat
  end
end
