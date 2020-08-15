defmodule SearchIndexTest do
  use ExUnit.Case

  @data %{"hello": "world"}
  @other_data %{"other": "stuff"}
  @id "some-id"
  @other_id "other-id"

  test "is empty by default" do
    result = SearchIndex.new()
      |> SearchIndex.search("hello")

    assert(result == [])
  end

  test "insert a document" do
    result = SearchIndex.new()
      |> SearchIndex.insert(@id, @data)
      |> SearchIndex.contains?(@id)

    assert(result)
  end

  test "remove a document" do
    result = SearchIndex.new()
      |> SearchIndex.insert(@id, @data)
      |> SearchIndex.remove(@id)
      |> SearchIndex.contains?(@id)

    assert(!result)
  end

  test "score inserted documents against a keyword" do
    expected = [
      %{score: 1.0, data: @data},
      %{score: 0.0, data: @other_data}
    ]

    result = SearchIndex.new()
      |> SearchIndex.insert(@id, @data)
      |> SearchIndex.insert(@other_id, @other_data)
      |> SearchIndex.search("world")

    assert(result == expected)
  end
end
