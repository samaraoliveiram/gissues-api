defmodule Gissues.GithubClient.Api do
  @behaviour Gissues.GithubClient.ApiBehaviour
  use HTTPoison.Base

  defp access_token, do: Application.get_env(:gissues, :gh_token)
  defp base_url, do: Application.get_env(:gissues, :base_url)
  defp per_page, do: Application.get_env(:gissues, :per_page)

  @next_page_regex ~r/<(?<url>[^>]*)>; rel=\"next\"/

  def list_resource(owner, repo, resource) do
    "/repos/#{owner}/#{repo}/#{resource}"
    |> do_list()
  end

  defp do_list(page_url) do
    with {:ok, data, headers} <- do_get(page_url) do
      case get_next_page(headers) do
        nil -> data
        url -> Enum.concat(data, do_list(url))
      end
    else
      _ -> :error
    end
  end

  @spec get_user_name(String.t()) :: map() | :error
  def get_user_name(username) do
    "/users/#{username}"
    |> do_get()
    |> case do
      {:ok, data, _} ->
        data

      _ ->
        :error
    end
  end

  # Apply a Regex to get Next Page link
  def get_next_page(headers) do
    with link when is_binary(link) <- Enum.find_value(headers, &find_link_header/1),
         %{url: url} <- Regex.named_captures(@next_page_regex, link) do
      url
    else
      _ -> nil
    end
  end

  defp do_get(url) do
    url
    |> get(headers())
    |> handle_response()
  end

  def process_url(url) do
    base_url() <> url <> "?#{params()}"
  end

  defp handle_response(resp) do
    case resp do
      {:ok, %{body: body, headers: headers, status_code: 200}} ->
        {:ok, body, headers}

      _ ->
        :error
    end

    # todo: handle other status code and an error message
  end

  def process_response_body(""), do: ""

  def process_response_body(body) do
    body
    |> Poison.decode!()
  end

  defp find_link_header({name, value}) do
    if(name == "Link", do: value)
  end

  defp params do
    %{per_page: per_page()}
    |> URI.encode_query()
  end

  defp headers do
    [
      {"Authorization", "token #{access_token()}"},
      {"Accept", " application/json"},
      {"Content-Type", "application/json"}
    ]
  end
end
