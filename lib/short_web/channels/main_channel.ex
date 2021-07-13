defmodule ShortWeb.MainChannel do
  use Phoenix.Channel

  def join("main", _message, socket) do
    {:ok, socket}
  end

  def handle_in("create_slug", %{"url" => url}, socket) do
    case Short.Url.create(url) do
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
