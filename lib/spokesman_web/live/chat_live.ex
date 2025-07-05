defmodule SpokesmanWeb.ChatLive do
  use SpokesmanWeb, :live_view

  alias Spokesman.UserMessages
  # alias Spokesman.Chats
  import SpokesmanWeb.ChatComponents

  def handle_params(%{"chat_id" => chat_id}, _uri, socket) do
    # chat = Chats.get_chat!(chat_id)

    messages = UserMessages.list_user_messages_for_chat(chat_id)

    socket = stream(socket, :messages, messages)

    IO.inspect(messages)

    {:noreply, socket}
  end
end
