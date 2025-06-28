defmodule SpokesmanWeb.ChatLive.Show do
  use SpokesmanWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    [first | _] = Chats.list_chats()
    socket = assign(socket, messages: first.messages)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <section>
      <ul>
        <%= for msg <- @messages do %>
          <li>{msg}</li>
        <% end %>
      </ul>
    </section>
    <section>
      <form phx-submit="send">
        <label>Message</label>
        <br />
        <input type="text" name="text" />
      </form>
    </section>
    <.table>
    </.table>
    """
  end

  def handle_event("send", %{"text" => text}, socket) do
    {:noreply, update(socket, :messages, &[text | &1])}
  end
end
