defmodule Recurly.Mixfile do
  use Mix.Project

  def project do
    [app: :recurly,
     version: "0.2.2",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     consolidate_protocols: Mix.env == :prod,
     docs: [main: "Recurly"],
     description: description(),
     package: package(),
     deps: deps(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
   ]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.9"},
      {:sweet_xml, "~> 0.6.1"},
      {:exml, "~> 0.1"},
      {:xml_builder, "~> 0.1"},
      {:ex_doc, "~> 0.11", only: :dev},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:excoveralls, "~> 0.5", only: :test},
      {:bypass, "~> 0.1", only: :test}
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
