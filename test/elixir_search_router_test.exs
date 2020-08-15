defmodule ElixirSearchRouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "check the status" do
    conn = ElixirSearchRouter.call(conn(:get, "/status"), [])
    assert(conn.status == 200)
    assert(conn.resp_body == "up")
  end

  test "search for a keyword in the index and find nothing" do
    {:ok, agent} = SearchIndexAgent.start_link()
    conn = ElixirSearchRouter.call(conn(:get, "/search/blah"), [index_agent: agent])
    assert(conn.status == 200)
    assert(conn.resp_body == "nothing")
  end

  test "search for a keyword in the index and find a result" do
    data = %{hello: "world"}

    {:ok, expected_json} = Jason.encode([
      %{data: data, score: 1.0}
    ])

    {:ok, agent} = SearchIndexAgent.start_link()
    SearchIndexAgent.insert(agent, "some-id", data)

    conn = ElixirSearchRouter.call(conn(:get, "/search/world"), [index_agent: agent])
    assert(conn.status == 200)
    assert(conn.resp_body == expected_json)
  end

  test "insert a document" do
    data = %{"hello" => "world"}

    {:ok, input_json} = Jason.encode(data)
    {:ok, agent} = SearchIndexAgent.start_link()

    conn = ElixirSearchRouter.call(conn(:put, "/documents/some-id", input_json), [index_agent: agent])

    index = SearchIndexAgent.get(agent)
    assert(SearchIndex.contains?(index, "some-id"))
    assert(SearchIndex.get(index, "some-id") == data)
  end

  test "get a document" do
    data = %{hello: "world"}

    {:ok, expected_json} = Jason.encode(data)
    {:ok, agent} = SearchIndexAgent.start_link()

    SearchIndexAgent.insert(agent, "some-id", data)

    conn = ElixirSearchRouter.call(conn(:get, "/documents/some-id"), [index_agent: agent])
    assert(conn.status == 200)
    assert(conn.resp_body == expected_json)
  end

  test "get a document that doesn't exist" do
    {:ok, agent} = SearchIndexAgent.start_link()
    conn = ElixirSearchRouter.call(conn(:get, "/documents/some-id"), [index_agent: agent])
    assert(conn.status == 404)
  end

  test "return 404 for a nonsense route" do
    conn = ElixirSearchRouter.call(conn(:get, "/nonsense"), [])
    assert(conn.status == 404)
  end
end