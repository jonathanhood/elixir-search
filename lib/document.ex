defmodule Document do

  def create(data) do
    %{grams: Grams.grams_for(data), data: data}
  end

  def score(left, right) do
    Grams.jaccard(left.grams, right.grams)
  end
end
