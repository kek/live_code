defmodule LiveCodeWeb.PageController do
  use LiveCodeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
