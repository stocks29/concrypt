defmodule Concrypt.Mixfile do
  use Mix.Project

  def project do
    [app: :concrypt,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps,
     mod: {Concrypt, []}]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:pkcs7, git: "https://github.com/camshaft/pkcs7.erl.git"},
      {:key_generator, git: "https://github.com/DisruptiveMind/elixir-pbkdf2.git"}
    ]
  end
end
