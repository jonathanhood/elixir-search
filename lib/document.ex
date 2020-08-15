defmodule Document do
  @enforce_keys [:grams, :data]
  defstruct grams: nil, data: %{}

  def create(data) do
    %Document{grams: Grams.grams_for(data), data: data}
  end

  def score(left, right) do
    Grams.jaccard(left.grams, right.grams)
  end
end
