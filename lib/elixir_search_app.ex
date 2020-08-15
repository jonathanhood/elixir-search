defmodule ElixirSearchApp do
  use Application

  def start(_type, _args) do
    agent = Agent.start_link(fn -> SearchIndex.new() end, name: SearchIndexAgent)
    Plug.Cowboy.http(ElixirSearchRouter, [index_agent: SearchIndexAgent])
  end
end