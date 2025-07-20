defmodule Spokesman.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias Spokesman.Repo

  alias Spokesman.Chats.Chat
  alias Spokesman.ChatUsers.ChatUser

  alias Spokesman.UserMessages.UserMessage

  def subscribe_to_chat_updates(chat_id) do
    Phoenix.PubSub.subscribe(Spokesman.PubSub, "chat:#{chat_id}:chat_updates")
  end

  def broadcast_chat_update(chat_id, message) do
    Phoenix.PubSub.broadcast(Spokesman.PubSub, "chat:#{chat_id}:chat_updates", message)
  end

  def unsubscribe_from_chat_updates(chat_id) do
    Phoenix.PubSub.unsubscribe(Spokesman.PubSub, "chat:#{chat_id}:chat_updates")
  end

  @doc """
  Returns the list of chats.

  ## Examples

      iex> list_chats()
      [%Chat{}, ...]

  """
  def list_chats do
    Repo.all(Chat)
  end

  def list_chats_for_user(user_id) do
    from(
      c in Chat,
      inner_join: cu in ChatUser,
      on: cu.chat_id == c.id,
      where: cu.user_id == ^user_id,
      order_by: [desc: c.updated_at, asc: c.id]
    )
    |> Repo.all()

    # TODO: add pagination
  end

  def update_last_user_message(%Chat{} = chat, %UserMessage{} = user_message) do
    chat
    |> Chat.change_last_user_message(user_message.id)
    |> Repo.update()
  end

  @doc """
  Gets a single chat.

  Raises `Ecto.NoResultsError` if the Chat does not exist.

  ## Examples

      iex> get_chat!(123)
      %Chat{}

      iex> get_chat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat!(id), do: Repo.get!(Chat, id)

  @doc """
  Creates a chat.

  ## Examples

      iex> create_chat(%{field: value})
      {:ok, %Chat{}}

      iex> create_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat(attrs \\ %{}) do
    %Chat{}
    |> Chat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chat.

  ## Examples

      iex> update_chat(chat, %{field: new_value})
      {:ok, %Chat{}}

      iex> update_chat(chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat(%Chat{} = chat, attrs) do
    chat
    |> Chat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chat.

  ## Examples

      iex> delete_chat(chat)
      {:ok, %Chat{}}

      iex> delete_chat(chat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat(%Chat{} = chat) do
    Repo.delete(chat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat changes.

  ## Examples

      iex> change_chat(chat)
      %Ecto.Changeset{data: %Chat{}}

  """
  def change_chat(%Chat{} = chat, attrs \\ %{}) do
    Chat.changeset(chat, attrs)
  end
end
