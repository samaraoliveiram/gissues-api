defmodule Gissues.FetchDataTest do
  use ExUnit.Case, async: true
  alias Gissues.FetchData
  import Mox

  setup :verify_on_exit!

  @repo "rumbl"
  @owner "samaraoliveiram"
  @resource ""

  Mox.defmock(GithubClient.ApiMock, for: Gissues.GithubClient.ApiBehaviour)

  describe "get repo issues and contributors" do
    test "returns issues and contributors from the specified repo" do
      GithubClient.ApiMock
      |> expect(:list_resource, 2, fn
        @owner, @repo, "issues" -> issues()
        @owner, @repo, "contributors" -> contributors()
      end)
      |> expect(:get_user_name, 1, fn @owner -> user() end)

      result =
        FetchData.get_repo_data(@owner, @repo)
        |> IO.inspect()

      assert =
        %{
          contributors: [
            %{"commits" => 2, "name" => "Samara Motta", "user" => "samaraoliveiram"}
          ],
          issues: [%{"author" => "samaraoliveiram", "labels" => [], "title" => "TEST"}],
          repository: "rumbl",
          user: "samaraoliveiram"
        } = result
    end
  end

  defp issues() do
    [
      %{
        "active_lock_reason" => nil,
        "assignee" => nil,
        "assignees" => [],
        "author_association" => "OWNER",
        "body" => "TEST",
        "closed_at" => nil,
        "comments" => 0,
        "comments_url" => "https://api.github.com/repos/samaraoliveiram/rumbl/issues/1/comments",
        "created_at" => "2021-09-01T20:13:48Z",
        "events_url" => "https://api.github.com/repos/samaraoliveiram/rumbl/issues/1/events",
        "html_url" => "https://github.com/samaraoliveiram/rumbl/issues/1",
        "id" => 985_618_129,
        "labels" => [],
        "labels_url" =>
          "https://api.github.com/repos/samaraoliveiram/rumbl/issues/1/labels{/name}",
        "locked" => false,
        "milestone" => nil,
        "node_id" => "MDU6SXNzdWU5ODU2MTgxMjk=",
        "number" => 1,
        "performed_via_github_app" => nil,
        "repository_url" => "https://api.github.com/repos/samaraoliveiram/rumbl",
        "state" => "open",
        "title" => "TEST",
        "updated_at" => "2021-09-01T20:13:48Z",
        "url" => "https://api.github.com/repos/samaraoliveiram/rumbl/issues/1",
        "user" => %{
          "avatar_url" => "https://avatars.githubusercontent.com/u/38509288?v=4",
          "events_url" => "https://api.github.com/users/samaraoliveiram/events{/privacy}",
          "followers_url" => "https://api.github.com/users/samaraoliveiram/followers",
          "following_url" =>
            "https://api.github.com/users/samaraoliveiram/following{/other_user}",
          "gists_url" => "https://api.github.com/users/samaraoliveiram/gists{/gist_id}",
          "gravatar_id" => "",
          "html_url" => "https://github.com/samaraoliveiram",
          "id" => 38_509_288,
          "login" => "samaraoliveiram",
          "node_id" => "MDQ6VXNlcjM4NTA5Mjg4",
          "organizations_url" => "https://api.github.com/users/samaraoliveiram/orgs",
          "received_events_url" => "https://api.github.com/users/samaraoliveiram/received_events",
          "repos_url" => "https://api.github.com/users/samaraoliveiram/repos",
          "site_admin" => false,
          "starred_url" => "https://api.github.com/users/samaraoliveiram/starred{/owner}{/repo}",
          "subscriptions_url" => "https://api.github.com/users/samaraoliveiram/subscriptions",
          "type" => "User",
          "url" => "https://api.github.com/users/samaraoliveiram"
        }
      }
    ]
  end

  defp contributors() do
    [
      %{
        "avatar_url" => "https://avatars.githubusercontent.com/u/38509288?v=4",
        "contributions" => 2,
        "events_url" => "https://api.github.com/users/samaraoliveiram/events{/privacy}",
        "followers_url" => "https://api.github.com/users/samaraoliveiram/followers",
        "following_url" => "https://api.github.com/users/samaraoliveiram/following{/other_user}",
        "gists_url" => "https://api.github.com/users/samaraoliveiram/gists{/gist_id}",
        "gravatar_id" => "",
        "html_url" => "https://github.com/samaraoliveiram",
        "id" => 38_509_288,
        "login" => "samaraoliveiram",
        "node_id" => "MDQ6VXNlcjM4NTA5Mjg4",
        "organizations_url" => "https://api.github.com/users/samaraoliveiram/orgs",
        "received_events_url" => "https://api.github.com/users/samaraoliveiram/received_events",
        "repos_url" => "https://api.github.com/users/samaraoliveiram/repos",
        "site_admin" => false,
        "starred_url" => "https://api.github.com/users/samaraoliveiram/starred{/owner}{/repo}",
        "subscriptions_url" => "https://api.github.com/users/samaraoliveiram/subscriptions",
        "type" => "User",
        "url" => "https://api.github.com/users/samaraoliveiram"
      }
    ]
  end

  defp user() do
    %{
      "avatar_url" => "https://avatars.githubusercontent.com/u/38509288?v=4",
      "bio" => nil,
      "blog" => "",
      "company" => nil,
      "created_at" => "2018-04-18T20:08:36Z",
      "email" => nil,
      "events_url" => "https://api.github.com/users/samaraoliveiram/events{/privacy}",
      "followers" => 11,
      "followers_url" => "https://api.github.com/users/samaraoliveiram/followers",
      "following" => 10,
      "following_url" => "https://api.github.com/users/samaraoliveiram/following{/other_user}",
      "gists_url" => "https://api.github.com/users/samaraoliveiram/gists{/gist_id}",
      "gravatar_id" => "",
      "hireable" => nil,
      "html_url" => "https://github.com/samaraoliveiram",
      "id" => 38_509_288,
      "location" => "São Paulo, Brazil",
      "login" => "samaraoliveiram",
      "name" => "Samara Motta",
      "node_id" => "MDQ6VXNlcjM4NTA5Mjg4",
      "organizations_url" => "https://api.github.com/users/samaraoliveiram/orgs",
      "public_gists" => 0,
      "public_repos" => 13,
      "received_events_url" => "https://api.github.com/users/samaraoliveiram/received_events",
      "repos_url" => "https://api.github.com/users/samaraoliveiram/repos",
      "site_admin" => false,
      "starred_url" => "https://api.github.com/users/samaraoliveiram/starred{/owner}{/repo}",
      "subscriptions_url" => "https://api.github.com/users/samaraoliveiram/subscriptions",
      "twitter_username" => "SamOliMotta",
      "type" => "User",
      "updated_at" => "2021-07-28T15:56:34Z",
      "url" => "https://api.github.com/users/samaraoliveiram"
    }
  end
end
