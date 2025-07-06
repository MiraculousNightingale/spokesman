defmodule SpokesmanWeb.ChatLive do
  use SpokesmanWeb, :live_view

  alias Spokesman.UserMessages
  alias Spokesman.UserMessages.UserMessage
  # alias Spokesman.Chats
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
      |> assign(:user_id, 1)

    {:ok, socket}
  end

  def handle_params(%{"chat_id" => chat_id}, _uri, socket) do
    messages = UserMessages.list_user_messages_for_chat(chat_id)
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
end
