defmodule Spokesman.Repo do
  use Ecto.Repo,
    otp_app: :spokesman,
    adapter: Ecto.Adapters.Postgres
end
