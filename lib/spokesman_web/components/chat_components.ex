defmodule SpokesmanWeb.ChatComponents do
  require Integer
  use SpokesmanWeb, :html

  def chat_list_item(assigns) do
    ~H"""
    <div class="py-2 px-2 flex flex-row items-center gap-2 bg-indigo-400">
      <div class="w-10 h-10 shrink-0 rounded-full bg-pink-400 flex items-center justify-center text-white">
        U
      </div>
      <div class="min-w-0">
        <p class="font-semibold">Username</p>
        <p class="truncate">
          Hello I wrote to you today, about your extended warranty, what do you think is going to happen now?
        </p>
      </div>
    </div>
    """
  end

  def chat_message_bubble(assigns) do
    ~H"""
    <%= if @message.user_id == 1 do %>
      <div class="p-2 m-2 w-fit rounded-2xl text-stone-100 max-w-[45%] mr-auto bg-message_incoming">
        {@message.text}
      </div>
    <% else %>
      <div class="p-2 m-2 w-fit rounded-2xl text-stone-100 max-w-[45%] ml-auto bg-message_outgoing">
        {@message.text}
      </div>
    <% end %>
    """
  end
end
