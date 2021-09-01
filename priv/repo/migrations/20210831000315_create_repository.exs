defmodule Gissues.Repo.Migrations.CreateRepository do
  use Ecto.Migration

  def change do

    create table(:repository) do
      add :content, :text

      timestamps()
    end
  end
end
