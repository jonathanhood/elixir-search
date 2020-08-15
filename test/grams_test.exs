defmodule GramsTest do
  use ExUnit.Case

  test "create grams for a string" do
    expected = MapSet.new(["hel", "ell", "llo"])
    assert(Grams.grams_for("hello") == expected)
  end

  test "create grams for a Grams" do
    expected = MapSet.new(["hel", "ell", "llo", "wor", "orl", "rld"])
    result = Grams.grams_for(%{first: "hello", second: "world"})
    assert(result == expected)
  end

  test "create grams for a nested Grams" do
    expected = MapSet.new(["hel", "ell", "llo", "wor", "orl", "rld", "oth", "the", "her"])
    result = Grams.grams_for(%{first: "hello", nested: %{second: "world", third: "other"}})
    assert(result == expected)
  end

  test "create grams for a Grams containing nonsense values" do
    expected = MapSet.new(["hel", "ell", "llo"])
    result = Grams.grams_for(%{first: "hello", second: 123})
    assert(result == expected)
  end

  test "return a 1.0 jaccard for equal strings" do
    left = Grams.grams_for("hello")
    assert(Grams.jaccard(left, left) == 1.0)
  end

  test "return a 0.0 jaccard for completely different strings" do
    left = Grams.grams_for("hello")
    right = Grams.grams_for("world")
    assert(Grams.jaccard(left, right) == 0.0)
  end

  test "return an intermediate value for similar strings" do
    left = Grams.grams_for("hello")
    right = Grams.grams_for("hellboy")
    assert(Grams.jaccard(left, right) == 1 / 3)
  end
end
