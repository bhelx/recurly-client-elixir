defmodule Recurly.Mixfile do
  use Mix.Project

  def project do
    [app: :recurly,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     consolidate_protocols: Mix.env == :prod,
     docs: [main: "Recurly"],
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8.0"},
      {:inflex, "~> 1.5.0"},
      {:sweet_xml, "~> 0.6.1"},
      {:exml, "~> 0.1"},
      {:xml_builder, "~> 0.0.8"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:credo, "~> 0.4", only: [:dev, :test]}
    ]
  end
end
