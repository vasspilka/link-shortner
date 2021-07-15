defmodule ShortWeb.PageControllerTest do
  use ShortWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Short URL"
  end

  describe "do_redirect/2 :: GET /:slug" do
    test "redirects when slug exists", %{conn: conn} do
      conn = get(conn, "/non_existing_slug")
      assert text_response(conn, 404) =~ "Error: Did not find url slug."
    end

    test "Returns text error when slug does not exist.", %{conn: conn} do
      url = "https://www.example.com/some/path"
      {:ok, %{slug: slug}} = Short.Urls.create_url(url)

      conn = get(conn, slug)
      assert redirected_to(conn, 302) == url
    end
  end
end
