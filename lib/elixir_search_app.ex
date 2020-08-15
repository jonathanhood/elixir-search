defmodule ElixirSearchApp do
  use Application

  def start(_type, _args) do
    {:ok, agent} = SearchIndexAgent.start_link()
    Plug.Cowboy.http(ElixirSearchRouter, [index_agent: agent])
  end
end