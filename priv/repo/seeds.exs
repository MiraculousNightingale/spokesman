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

Ecto.Multi.new()
# Chat
|> Ecto.Multi.insert(:chat, %Chat{})
# Chat Users
|> Ecto.Multi.insert(:chat_user_bob, fn %{chat: chat} ->
  %ChatUser{chat: chat, user: bob}
end)
|> Ecto.Multi.insert(:chat_user_jimmy, fn %{chat: chat} ->
  %ChatUser{chat: chat, user: jimmy}
end)
|> Ecto.Multi.insert(:bob_message_1, fn %{chat: chat} ->
  %UserMessage{chat: chat, user: bob, text: "Good day, Jimmy!"}
end)
# Messages
|> Ecto.Multi.insert(:jimmy_message_1, fn %{chat: chat} ->
  %UserMessage{chat: chat, user: jimmy, text: "Hello, Bob! How's your day?"}
end)
|> Ecto.Multi.insert(:bob_message_2, fn %{chat: chat} ->
  %UserMessage{chat: chat, user: bob, text: "It's great, what about you?"}
end)
|> Ecto.Multi.insert(:jimmy_message_2, fn %{chat: chat} ->
  %UserMessage{chat: chat, user: jimmy, text: "I've got a question for you, Bob."}
end)
|> Ecto.Multi.insert(:bob_message_3, fn %{chat: chat} ->
  %UserMessage{chat: chat, user: bob, text: "What's that, Jim?"}
end)
|> Ecto.Multi.insert(:jimmy_message_3, fn %{chat: chat} ->
  %UserMessage{chat: chat, user: jimmy, text: "Sosal?"}
end)
|> Ecto.Multi.insert(:bob_message_4, fn %{chat: chat} ->
  %UserMessage{chat: chat, user: bob, text: "Sosal"}
end)
|> Repo.transaction()
