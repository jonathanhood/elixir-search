defmodule SearchIndex do

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  def new() do
    %{}
  end

  def insert(bucket, id, data) do
    doc = Document.create(data)
    Map.put(bucket, id, doc)
  end

  def remove(bucket, id) do
    {_, updated} = Map.pop(bucket, id)
    updated
  end

  def contains?(bucket, id) do
    Map.has_key?(bucket, id)
  end

  def get(bucket, id) do
    Map.get(bucket, id).data
  end

  def search(bucket, keyword) do
    score_docs(keyword, Map.values(bucket))
  end

  defp score_docs(keyword, documents) do
    keyword_grams = Grams.grams_for(keyword)
    Enum.map(documents, fn doc -> doc |> score_doc(keyword_grams) end)
      |> Enum.sort_by(&Map.fetch(&1, :score))
      |> Enum.reverse()
      |> Enum.take(10)
  end

  defp score_doc(doc, keyword_grams) do
    %{score: Grams.jaccard(doc.grams, keyword_grams), data: doc.data}
  end
end
