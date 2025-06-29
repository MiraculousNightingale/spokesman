defmodule Spokesman.UserMessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Spokesman.UserMessages` context.
  """

  @doc """
  Generate a user_message.
  """
  def user_message_fixture(attrs \\ %{}) do
    {:ok, user_message} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> Spokesman.UserMessages.create_user_message()

    user_message
  end
end
