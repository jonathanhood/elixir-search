defmodule ElixirSearch.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_search,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :cowboy, :plug],
      mod: {ElixirSearchApp, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.3"},
      {:jason, "~> 1.2"}
    ]
  end
end
