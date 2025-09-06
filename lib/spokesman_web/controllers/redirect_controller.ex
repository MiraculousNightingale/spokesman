defmodule SpokesmanWeb.RedirectController do
  use SpokesmanWeb, :controller

  @doc """
  Redirects to route specified in `conn.private.redirect_to`
  """
  def to(conn, _params) do
    %{redirect_to: to} = conn.private
    redirect(conn, to: to)
  end
end
