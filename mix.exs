defmodule Recurly.Mixfile do
  use Mix.Project

  def project do
    [app: :recurly,
     version: "0.1.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     consolidate_protocols: Mix.env == :prod,
     docs: [main: "Recurly"],
     description: description,
     package: package,
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

  defp description do
    """
    An elixir client for the Recurly API https://dev.recurly.com/
    """
  end

  defp package do
    [
      name: :recurly,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Benjamin Eckel"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/bhelx/recurly-client-elixir"}
    ]
  end
end
