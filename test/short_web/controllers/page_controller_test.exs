defmodule ShortWeb.PageControllerTest do
  use ShortWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Short URL"
  end
end
