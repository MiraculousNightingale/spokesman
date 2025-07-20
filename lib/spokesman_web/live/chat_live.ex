defmodule SpokesmanWeb.ChatLive do
  use SpokesmanWeb, :live_view

  alias Spokesman.Repo
  alias Spokesman.Chats
  alias Spokesman.Chats.Chat
  alias Spokesman.Users
  alias Spokesman.Users.User
  alias Spokesman.UserMessages
  alias Spokesman.UserMessages.UserMessage

  import SpokesmanWeb.ChatComponents

  def mount(_unsigned_params, _session, socket) do
    %{current_user: %User{id: current_user_id}} = socket.assigns

    Users.subscribe_to_chat_updates(current_user_id)

    chats =
      Chats.list_chats_for_user(current_user_id)
      |> Repo.preload([:users, :last_user_message])
      |> Enum.map(&chat_element(&1))

    form =
      %UserMessage{}
      |> UserMessages.change_user_message()
      |> to_form()

    socket =
      socket
      |> assign(:new_message_form, form)
      |> stream(:chats, chats)

    {:ok, socket}
  end

  def handle_params(%{"chat_id" => chat_id}, _uri, socket) do
    chat_id = String.to_integer(chat_id)

    if Map.has_key?(socket.assigns, :chat_id) do
      Chats.unsubscribe_from_chat_updates(socket.assigns.chat_id)
    end

    Chats.subscribe_to_chat_updates(chat_id)

    chat_users = Users.list_users_for_chat(chat_id)

    messages =
      UserMessages.list_user_messages_for_chat(chat_id)
      |> Enum.map(&message_element(&1))

    socket =
      socket
      |> assign(:chat_id, chat_id)
      |> assign(:chat_users, chat_users)
      |> stream(:messages, messages, reset: true)
      |> push_event("spokesman:chat_selected", %{chat_id: chat_id})

    {:noreply, socket}
  end

  def handle_event("changed", %{"user_message" => message}, socket) do
    form =
      %UserMessage{}
      |> UserMessages.change_user_message(message)
      |> to_form()

    socket =
      socket
      |> assign(:new_message_form, form)

    {:noreply, socket}
  end

  def handle_event("send", %{"user_message" => message}, socket) do
    %{
      chat_id: chat_id,
      current_user: current_user,
      chat_users: chat_users
    } = socket.assigns

    message =
      message
      |> Map.merge(%{
        "chat_id" => chat_id,
        "user_id" => current_user.id
      })

    case UserMessages.add_user_message(message) do
      {:ok, message} ->
        form =
          %UserMessage{}
          |> UserMessages.change_user_message()
          |> to_form()

        message_element = message_element(message)
        chat_element = chat_element(current_user, message)

        socket =
          socket
          |> assign(:new_message_form, form)
          |> stream_insert(:messages, message_element)
          |> stream_insert(:chats, chat_element)
          |> push_event("spokesman:chat_message_added", %{})

        Chats.broadcast_chat_update(chat_id, {:chat_message_added, message_element})

        chat_users
        |> Enum.each(
          &Users.broadcast_chat_update(
            &1.id,
            {:chat_last_message_updated, chat_element}
          )
        )

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> assign(:new_message_form, to_form(changeset))

        {:noreply, socket}

      {:error, reason} when is_binary(reason) ->
        put_flash(socket, :error, reason)

        {:noreply, socket}
    end
  end

  def handle_info({:chat_last_message_updated, chat_element}, socket) do
    {:noreply, stream_insert(socket, :chats, chat_element)}
  end

  def handle_info({:chat_message_added, message_element}, socket) do
    {:noreply, stream_insert(socket, :messages, message_element)}
  end

  defp chat_element(%Chat{id: id, users: users, last_user_message: last_user_message}) do
    %{
      id: id,
      user_name: List.first(users).name,
      user_first_letter: String.first(List.first(users).name),
      last_message_text: last_user_message.text
    }
  end

  defp chat_element(%User{name: name}, %UserMessage{chat_id: id, text: text}) do
    %{
      id: id,
      user_name: name,
      user_first_letter: String.first(name),
      last_message_text: text
    }
  end

  defp message_element(%UserMessage{id: id, text: text, user_id: user_id}) do
    %{
      id: id,
      text: text,
      user_id: user_id
    }
  end
end
