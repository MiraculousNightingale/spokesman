# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Spokesman.Repo.insert!(%Spokesman.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Spokesman.Chats
alias Spokesman.ChatUsers.ChatUser
alias Spokesman.Repo
alias Spokesman.Chats.Chat
alias Spokesman.UserMessages.UserMessage
alias Spokesman.Users
alias Spokesman.Users.User

bob =
  %User{}
  |> User.registration_changeset(%{
    name: "Bob",
    email: "bob@gmail.com",
    password: "bobson123456"
  })
  |> Repo.insert!()

jimmy =
  %User{}
  |> User.registration_changeset(%{
    name: "Jimmy",
    email: "jimmy@gmail.com",
    password: "saulgoodman1"
  })
  |> Repo.insert!()

# Chat
chat =
  %Chat{is_direct: true}
  |> Chat.changeset(%{})
  |> Repo.insert!()

# Chat Users
Ecto.Multi.new()
|> Ecto.Multi.insert(:chat_user_bob, fn %{} ->
  %ChatUser{chat: chat, user: bob}
end)
|> Ecto.Multi.insert(:chat_user_jimmy, fn %{} ->
  %ChatUser{chat: chat, user: jimmy}
end)
# Messages
|> Ecto.Multi.insert(:bob_message_1, fn %{} ->
  %UserMessage{chat: chat, user: bob, text: "Good day, Jimmy!"}
end)
|> Ecto.Multi.insert(:jimmy_message_1, fn %{} ->
  %UserMessage{chat: chat, user: jimmy, text: "Hello, Bob! How's your day?"}
end)
|> Ecto.Multi.insert(:bob_message_2, fn %{} ->
  %UserMessage{chat: chat, user: bob, text: "It's great, what about you?"}
end)
|> Ecto.Multi.insert(:jimmy_message_2, fn %{} ->
  %UserMessage{chat: chat, user: jimmy, text: "I've got a question for you, Bob."}
end)
|> Ecto.Multi.insert(:bob_message_3, fn %{} ->
  %UserMessage{chat: chat, user: bob, text: "What's that, Jim?"}
end)
|> Ecto.Multi.insert(:jimmy_message_3, fn %{} ->
  %UserMessage{chat: chat, user: jimmy, text: "Sosal?"}
end)
|> Repo.transaction()

last_message =
  %UserMessage{chat: chat, user: bob, text: "Sosal"}
  |> UserMessage.changeset(%{})
  |> Repo.insert!()

chat
|> Chats.update_last_user_message(last_message)

# Chat
chat =
  %Chat{is_direct: true}
  |> Chat.changeset(%{})
  |> Repo.insert!()

# Chat Users
Ecto.Multi.new()
|> Ecto.Multi.insert(:chat_user_bob, fn %{} ->
  %ChatUser{chat: chat, user: bob}
end)
|> Ecto.Multi.insert(:chat_user_jimmy, fn %{} ->
  %ChatUser{chat: chat, user: jimmy}
end)
# Messages
|> Ecto.Multi.insert(:bob_message_1, fn %{} ->
  %UserMessage{chat: chat, user: bob, text: "Wow this is another chat!"}
end)
|> Ecto.Multi.insert(:jimmy_message_1, fn %{} ->
  %UserMessage{chat: chat, user: jimmy, text: "Yeah, it's like the second one"}
end)
|> Ecto.Multi.insert(:bob_message_2, fn %{} ->
  %UserMessage{chat: chat, user: bob, text: "Nice"}
end)
|> Ecto.Multi.insert(:jimmy_message_2, fn %{} ->
  %UserMessage{chat: chat, user: jimmy, text: "Yeah"}
end)
|> Repo.transaction()

last_message =
  %UserMessage{chat: chat, user: bob, text: "How about switching between them?"}
  |> UserMessage.changeset(%{})
  |> Repo.insert!()

chat
|> Chats.update_last_user_message(last_message)
