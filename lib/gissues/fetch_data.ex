defmodule Gissues.FetchData do
  def api_client, do: Application.get_env(:gissues, :api_client)

  def get_repo_data(owner, repo) do
    issues =
      call_api!(owner, repo, "issues")
      |> Enum.map(&format_issue/1)

    contributors =
      call_api!(owner, repo, "contributors")
      |> Enum.map(&format_contributor/1)
      |> Task.async_stream(&fetch_name/1)
      |> Stream.reject(&(&1 == :error))
      |> Stream.map(fn {:ok, user} -> user end)
      |> Enum.into([])

    %{
      user: owner,
      issues: issues,
      repository: repo,
      contributors: contributors
    }
  end

  defp fetch_name(cont) do
    case call_api!(cont["user"]) do
      :error ->
        :error

      user ->
        user
        |> Map.take(["name"])
        |> Map.merge(cont)
    end
  end

  defp format_contributor(%{"login" => login, "contributions" => commits}) do
    %{"user" => login, "commits" => commits}
  end

  defp format_issue(issue) do
    issue
    |> Map.put("author", get_in(issue, ["user", "login"]))
    |> Map.update("labels", [], fn labels -> Enum.map(labels, &Map.get(&1, "name")) end)
    |> Map.take(["title", "labels", "author"])
  end

  defp call_api!(owner, repo, resource) do
    api_client().list_resource(owner, repo, resource)
  end

  defp call_api!(key) do
    api_client().get_user_name(key)
  end
end
