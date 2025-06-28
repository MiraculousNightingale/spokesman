defmodule Chat do
  defstruct messages: []
end

defmodule Chats do
  def list_chats do
    [
      %Chat{
        messages: [
          "Hello.",
          "How you doing?",
          "Doing good."
        ]
      },
      %Chat{
        messages: [
          "Hi, it's me, Jimmy!",
          "Yo, wassup."
        ]
      },
      %Chat{
        messages: [
          "Nice weather today, eh?"
        ]
      }
    ]
  end
end
