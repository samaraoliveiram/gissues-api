defmodule Gissues.GithubClient.ApiTest do
  use ExUnit.Case, async: true

  test "get_next_page parses url from headers" do
    headers = [
      {"Link",
       "<https://api.github.com/repositories/1234714/issues?per_page=1&page=2>; rel=\"next\", <https://api.github.com/repositories/1234714/issues?per_page=1&page=22>; rel=\"last\""}
    ]

    assert GithubApi.get_next_page(headers) ==
             "https://api.github.com/repositories/1234714/issues?per_page=1&page=2"
  end
end
