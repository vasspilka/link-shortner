defmodule ShortWeb.PageController do
  use ShortWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def do_redirect(conn, %{"slug" => slug}) do
    case Short.Urls.get_url(slug) do
      {:ok, %{url: url}} ->
        redirect(conn, external: url)

      {:error, :not_found} ->
        conn
        |> put_status(404)
        |> text("Error: Did not find url slug.")
    end
  end
end
