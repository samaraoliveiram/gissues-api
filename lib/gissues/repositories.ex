defmodule Gissues.Repositories do
  alias Gissues.Repo
  import Ecto.Query, warn: false
  alias Gissues.Repositories.Repository

  def create_repo(attrs \\ %{}) do
    %Repository{}
    |> Repository.changeset(attrs)
    |> Repo.insert()
  end

  def get_repo!(id), do: Repo.get!(Repository, id)
end
