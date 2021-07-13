defmodule ShortWeb.MainChannelTest do
  use ShortWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      ShortWeb.UserSocket
      |> socket("user_id", %{})
      |> subscribe_and_join(ShortWeb.MainChannel, "main")

    %{socket: socket}
  end

  test "can create slug for valid urls", %{socket: socket} do
    url = "https://www.example.com/some/path"

    push(socket, "create_slug", %{"url" => url})

    assert_broadcast("send_url", %{slug: slug})
    assert is_binary(slug)
  end

  test "Will return error when url is not valid", %{socket: socket} do
    url = "hts://wwwexample.com/some/path"

    push(socket, "create_slug", %{"url" => url})

    assert_broadcast("display_error", %{error: error})
    assert error == "[url: {\"Is not valid.\", []}]"
  end
end
