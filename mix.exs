defmodule Exchange.MixProject do
  use Mix.Project

  def project do
    [
      app: :exchange,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Exchange.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:tesla, "~> 1.4.4"},
      {:bypass, "~> 2.1"},
    ]
  end
end
