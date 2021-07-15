defmodule Short.Urls.UrlTest do
  use Short.DataCase

  alias Short.Urls.Url

  describe "get/1" do
    test "returns error when slug does not exist" do
      url = "https://www.example.com/some/path"

      hashed_slug =
        :crypto.hash(:sha, url)
        |> Base.encode16()

      assert {:error, :not_found} = Url.get(hashed_slug)
    end

    test "can fetch existing slug" do
      {:ok, %{slug: slug, url: url}} = Url.create("https://www.example.com/some/path")

      assert {:ok, %Url{slug: ^slug, url: ^url}} = Url.get(slug)
    end
  end

  describe "create/1" do
    test "can create slug for url when it does not exist" do
      url = "https://www.example.com/some/path"

      assert {:ok, %Url{url: ^url}} = Url.create(url)
    end

    test "when creating with same http will return existing url" do
      url = "https://www.example.com/some/path"

      assert {:ok, %Url{url: ^url}} = Url.create(url)
      assert {:ok, %Url{url: ^url}} = Url.create(url)
      assert {:ok, %Url{url: ^url}} = Url.create(url)

      assert Repo.aggregate(Url, :count) == 1
    end

    test "will validate that the url is correct" do
      bad_url_1 = "://example!com/some/path"
      bad_url_2 = "example/some/path"

      assert {:error, %Ecto.Changeset{errors: [url: {"Is not valid.", []}]}} =
               Url.create(bad_url_1)

      assert {:error, %Ecto.Changeset{errors: [url: {"Is not valid.", []}]}} =
               Url.create(bad_url_2)

      assert Repo.aggregate(Url, :count) == 0
    end
  end
end
