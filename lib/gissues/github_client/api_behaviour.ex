defmodule Gissues.GithubClient.ApiBehaviour do
  @moduledoc false
  @callback list_resource(String.t(), String.t(), String.t()) :: map() | :error
  @callback get_user_name(String.t()) :: map() | :error
  @callback get_next_page(list(tuple())) :: String.t() | nil
end
