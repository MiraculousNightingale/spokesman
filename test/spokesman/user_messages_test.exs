defmodule Spokesman.UserMessagesTest do
  use Spokesman.DataCase

  alias Spokesman.UserMessages

  describe "user_messages" do
    alias Spokesman.UserMessages.UserMessage

    import Spokesman.UserMessagesFixtures

    @invalid_attrs %{text: nil}

    test "list_user_messages/0 returns all user_messages" do
      user_message = user_message_fixture()
      assert UserMessages.list_user_messages() == [user_message]
    end

    test "get_user_message!/1 returns the user_message with given id" do
      user_message = user_message_fixture()
      assert UserMessages.get_user_message!(user_message.id) == user_message
    end

    test "create_user_message/1 with valid data creates a user_message" do
      valid_attrs = %{text: "some text"}

      assert {:ok, %UserMessage{} = user_message} = UserMessages.create_user_message(valid_attrs)
      assert user_message.text == "some text"
    end

    test "create_user_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserMessages.create_user_message(@invalid_attrs)
    end

    test "update_user_message/2 with valid data updates the user_message" do
      user_message = user_message_fixture()
      update_attrs = %{text: "some updated text"}

      assert {:ok, %UserMessage{} = user_message} = UserMessages.update_user_message(user_message, update_attrs)
      assert user_message.text == "some updated text"
    end

    test "update_user_message/2 with invalid data returns error changeset" do
      user_message = user_message_fixture()
      assert {:error, %Ecto.Changeset{}} = UserMessages.update_user_message(user_message, @invalid_attrs)
      assert user_message == UserMessages.get_user_message!(user_message.id)
    end

    test "delete_user_message/1 deletes the user_message" do
      user_message = user_message_fixture()
      assert {:ok, %UserMessage{}} = UserMessages.delete_user_message(user_message)
      assert_raise Ecto.NoResultsError, fn -> UserMessages.get_user_message!(user_message.id) end
    end

    test "change_user_message/1 returns a user_message changeset" do
      user_message = user_message_fixture()
      assert %Ecto.Changeset{} = UserMessages.change_user_message(user_message)
    end
  end
end
