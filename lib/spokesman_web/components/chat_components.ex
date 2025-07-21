defmodule SpokesmanWeb.ChatComponents do
  require Integer
  use SpokesmanWeb, :html

  def chat_list_item(assigns) do
    ~H"""
    <.link id={@id} patch={~p"/chats/#{@chat.id}"}>
      <div class={"py-2 px-2 flex flex-row items-center gap-2 #{if @chat.id == @current_chat_id do "selected-chat" else "unselected-chat" end}"}>
        <div class="w-10 h-10 shrink-0 rounded-full bg-pink-400 flex items-center justify-center text-white">
          {@chat.user_first_letter}
        </div>
        <div class="min-w-0">
          <p class="font-semibold">{@chat.user_name}</p>
          <p class="truncate">
            {@chat.last_message_text}
          </p>
        </div>
      </div>
    </.link>
    """
  end

  def chat_message_bubble(assigns) do
    ~H"""
    <%= if @message.user_id != @current_user_id do %>
      <div
        id={@id}
        class="p-2 m-2 w-fit rounded-2xl text-stone-100 max-w-[45%] mr-auto bg-message_incoming"
      >
        {@message.text}
      </div>
    <% else %>
      <div
        id={@id}
        class="p-2 m-2 w-fit rounded-2xl text-stone-100 max-w-[45%] ml-auto bg-message_outgoing"
      >
        {@message.text}
      </div>
    <% end %>
    """
  end
end
