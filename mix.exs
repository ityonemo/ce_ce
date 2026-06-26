defmodule CeCe.MixProject do
  use Mix.Project

  def project do
    [
      app: :ce_ce,
      version: "0.2.0",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/_support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:protoss, "~> 1.1.0"},
      {:proton_stream, "~> 1.8.2"},
      {:telemetry, "~> 1.0"},
      {:elixir_uuid, "~> 1.2"}
    ]
  end
end
