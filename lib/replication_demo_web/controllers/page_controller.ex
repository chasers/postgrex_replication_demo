defmodule ReplicationDemoWeb.PageController do
  use ReplicationDemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
