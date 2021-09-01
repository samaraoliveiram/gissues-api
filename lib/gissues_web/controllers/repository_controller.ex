defmodule GissuesWeb.RepositoryController do
  use GissuesWeb, :controller

  alias Gissues.FetchData
  alias Gissues.Repositories
  alias Gissues.Workers.ScheduleResponse

  @webhook "https://webhook.site/d0b76508-0268-47df-afbd-b7c25c103db4"

  def request(
        %Plug.Conn{body_params: %{"username" => username, "repository" => repository}} = conn,
        _params
      ) do
    spawn(fn ->
      process_async(username, repository, Map.get(conn.body_params, "webhook", @webhook))
    end)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "")
  end

  defp process_async(username, repository, webhook) do
    {:ok, data} = Poison.encode(FetchData.get_repo_data(username, repository))
    {:ok, repo} = Repositories.create_repo(%{content: data})

    %{id: repo.id, webhook: webhook}
    |> ScheduleResponse.new(schedule_in: {1, :day})
    |> Oban.insert()
  end
end
