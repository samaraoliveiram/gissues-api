defmodule GissuesWeb.PageController do
  use GissuesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
