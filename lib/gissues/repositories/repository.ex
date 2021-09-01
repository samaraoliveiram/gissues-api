defmodule Gissues.Repositories.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  schema "repository" do
    field :content, :string
    timestamps()
  end

  def changeset(repo, attrs) do
    repo
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
