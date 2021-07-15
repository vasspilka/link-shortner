defmodule Short.Urls do
  @moduledoc """
  Context module for urls, this is the top level module used to interact
  with the Url shortening context.
  """

  alias Short.Urls.Url

  @spec get_url(binary()) :: {:ok, Url.t()} | {:error, :not_found}
  defdelegate get_url(slug), to: Url, as: :get

  @spec create_url(binary()) :: {:ok, Url.t()} | {:error, Ecto.Changeset.t()} | {:error, term()}
  defdelegate create_url(url), to: Url, as: :create
end
