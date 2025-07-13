defmodule SpokesmanWeb.ChatLive do
  use SpokesmanWeb, :live_view

  alias Spokesman.Repo
alias Spokesman.Chats
  alias Spokesman.Chats.Chat
  alias Spokesman.Users.User
  alias Spokesman.UserMessages
  alias Spokesman.UserMessages.UserMessage
  
  import SpokesmanWeb.ChatComponents

  def mount(%{"chat_id" => chat_id}, _session, socket) do
    form =
      %UserMessage{}
      |> UserMessages.change_user_message()
      |> to_form()

    socket =
      socket
      |> assign(:new_message_form, form)
      |> assign(:chat_id, chat_id)

    {:ok, socket}
  end

  def handle_params(%{"chat_id" => chat_id}, _uri, socket) do
%{current_user: %User{} = current_user} = socket.assigns

    chats =
      Chats.list_chats_for_user(current_user.id)
      |> Repo.preload([:users, :last_user_message])
      |> Enum.map(&chat_element(&1))

    socket = stream(socket, :chats, chats)

    messages =
UserMessages.list_user_messages_for_chat(chat_id)
|> Enum.map(&message_element(current_user, &1))

    socket = stream(socket, :messages, messages)

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
    %{chat_id: chat_id, user_id: user_id} = socket.assigns

    message =
      message
      |> Map.merge(%{
        "chat_id" => chat_id,
        "user_id" => user_id
      })

    case UserMessages.create_user_message(message) do
      {:ok, message} ->
        form =
          %UserMessage{}
          |> UserMessages.change_user_message()
          |> to_form()

        socket =
          socket
          |> assign(:new_message_form, form)
          |> stream_insert(:messages, message)

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(:new_message_form, to_form(changeset))

        {:noreply, socket}
    end
  end

  defp chat_element(%Chat{id: id, users: users, last_user_message: last_user_message}) do
    %{
      id: id,
      user_name: List.first(users).name,
      user_first_letter: String.first(List.first(users).name),
      last_message_text: last_user_message.text
    }
  end

  defp message_element(
         %User{id: current_user_id},
         %UserMessage{
           id: id,
           text: text,
           user_id: user_id
         }
       ) do
    %{
      id: id,
      text: text,
      is_incoming: user_id != current_user_id
    }
  end
end
