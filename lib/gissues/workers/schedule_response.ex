defmodule Gissues.Workers.ScheduleResponse do
  use Oban.Worker

  alias Gissues.Repositories
  alias Gissues.Repositories.Repository

  @impl Oban.Worker
  def perform(%{args: %{"id" => id, "webhook" => webhook}}) do
    %Repository{content: content} = Repositories.get_repo!(id)

    HTTPoison.post!(webhook, content)

    :ok
  end

  def perform(_arg), do: IO.puts("IAUGFIUYASGFUIYASGDYUIFGASDYUIFGIASYUDFGIASDYUFG")
end
