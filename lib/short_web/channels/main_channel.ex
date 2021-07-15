defmodule ShortWeb.MainChannel do
  @moduledoc """
  Main channel for communicating with browser client.
  """
  use Phoenix.Channel

  alias Short.Urls

  def join("main", _message, socket) do
    {:ok, socket}
  end

  def handle_in("create_slug", %{"url" => url}, socket) do
    case Urls.create_url(url) do
      {:ok, %{slug: slug}} ->
        broadcast!(socket, "send_url", %{slug: slug})

      {:error, %{errors: errors}} ->
        broadcast!(socket, "display_error", %{error: inspect(errors)})

      {:error, _} ->
        broadcast!(socket, "display_error", %{error: "Unknown error."})
    end

    {:noreply, socket}
  end
end
