defmodule Gissues.Repo do
  use Ecto.Repo,
    otp_app: :gissues,
    adapter: Ecto.Adapters.Postgres
end
