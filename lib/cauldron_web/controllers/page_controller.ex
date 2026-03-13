defmodule CauldronWeb.PageController do
  use CauldronWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
