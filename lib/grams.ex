defmodule Grams do
  def jaccard(left, right) do
    numerator = MapSet.size(MapSet.intersection(left, right))
    denominator = MapSet.size(left) + MapSet.size(right) - numerator
    numerator / denominator
  end

  def grams_for(value) when is_map(value) do
    Enum.reduce(Map.values(value), MapSet.new(), fn v, acc -> MapSet.union(grams_for(v), acc) end)
  end

  def grams_for(value) when is_bitstring(value) do
    grams_for(value, MapSet.new())
  end

  def grams_for(_) do
    MapSet.new()
  end

  def grams_for(value, results) when is_bitstring(value) do
    if String.length(value) < 3 do
      results
    else
      gram = String.slice(value, 0, 3)
      remaining = String.slice(value, 1, String.length(value))
      grams_for(remaining, MapSet.put(results, gram))
    end
  end
end
