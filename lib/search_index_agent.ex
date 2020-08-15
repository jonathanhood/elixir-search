defmodule SearchIndexAgent do
  use Agent

  def start_link(opts \\ []) do
    Agent.start_link(fn -> SearchIndex.new() end, opts)
  end

  def get(ref) do
    Agent.get(ref, & &1)
  end

  def insert(ref, id, data) do
    Agent.update(ref, &SearchIndex.insert(&1, id, data))
  end
end
