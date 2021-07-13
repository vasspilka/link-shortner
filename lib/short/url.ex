defmodule Short.Url do
  @moduledoc """
  Schema for our URL structure.

  It is used to create URL slugs which can later be used to retrive
  the url.
  """
  use Ecto.Schema

  alias Short.Repo
  alias Short.Url

  import Ecto.Changeset

  @type t() :: %__MODULE__{
          url: binary(),
          slug: binary
        }

  @http_regex ~r/^(?:(?:https?):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\x{00a1}-\x{ffff}0-9]+-?)*[a-z\x{00a1}-\x{ffff}0-9]+)(?:\.(?:[a-z\x{00a1}-\x{ffff}0-9]+-?)*[a-z\x{00a1}-\x{ffff}0-9]+)*(?:\.(?:[a-z\x{00a1}-\x{ffff}]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?$/ius

  @primary_key {:slug, :string, autogenerate: false}
  schema "short_url" do
    field(:url, :string)
  end

  @doc "Returns the url based on it's slug if exists"
  @spec get(binary()) :: {:ok, t()} | {:error, :not_found}
  def get(slug) do
    Repo.get(Url, slug)
    |> case do
      nil -> {:error, :not_found}
      url -> {:ok, url}
    end
  end

  @doc "Will create slug for new url and insert it into the database if it's valid."
  @spec create(binary()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def create(url) do
    slug = create_slug(url)

    attrs = %{
      url: url,
      slug: slug
    }

    result =
      %Url{}
      |> cast(attrs, [:url, :slug])
      |> unique_constraint(:slug, name: :short_url_pkey)
      |> validate_change(:url, fn _, value ->
        case String.match?(value, @http_regex) do
          true -> []
          false -> [url: "Is not valid."]
        end
      end)
      |> Repo.insert()

    with {:error,
          %Ecto.Changeset{
            errors: [
              slug:
                {"has already been taken",
                 [constraint: :unique, constraint_name: "short_url_pkey"]}
            ]
          }} <- result do
      get(slug)
    end
  end

  defp create_slug(url) do
    :crypto.hash(:md5, url)
    |> Base.encode16()
  end
end
