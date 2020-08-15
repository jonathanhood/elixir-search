defmodule SearchIndexAgentTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, agent} = SearchIndexAgent.start_link()
    %{agent: agent}
  end

  test "contain nothing by default", %{agent: agent} do
    index = SearchIndexAgent.get(agent)
    assert(index == %{})
  end

  test "insert a document", %{agent: agent}  do
    SearchIndexAgent.insert(agent, "some-id", %{hello: "world"})
    exists = SearchIndexAgent.get(agent) |> SearchIndex.contains?("some-id")
    assert(exists)
  end
end