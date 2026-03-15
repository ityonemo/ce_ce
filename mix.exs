defmodule CeCe.MixProject do
  use Mix.Project

  def project do
    [
      app: :ce_ce,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:proton_stream, "~> 1.8.1"}
    ]
  end
end
