defmodule DocumentTest do
  use ExUnit.Case

  test "create and compare two completely different documents" do
    doc1 = Document.create(%{"hello" => "world"})
    doc2 = Document.create(%{"goodbye" => "blueskies"})
    assert(doc1.grams == MapSet.new(["wor", "orl", "rld"]))
    assert(doc2.grams == MapSet.new(["blu", "lue", "ues", "esk", "ski", "kie", "ies"]))
    assert(Document.score(doc1, doc2) == 0.0)
  end

  test "compare the same document" do
    doc1 = Document.create(%{"hello" => "world"})
    assert(Document.score(doc1, doc1) == 1.0)
  end
end
