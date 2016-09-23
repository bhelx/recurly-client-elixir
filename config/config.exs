# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

if Mix.env == :test do
  # load with test keys
  config :recurly,
    private_key: "15f32756c9c90b83f2231e638de98bf1",
    subdomain: "mysubdomain"

  config :logger, level: :error
else
  # load with system env by default
  config :recurly,
    private_key: System.get_env("RECURLY_DEV_KEY"),
    subdomain: System.get_env("RECURLY_DEV_SUBDOMAIN")

  config :logger, level: :debug
end

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :recurly, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:recurly, :key)
#
# Or configure a 3rd-party app:
#
#config :logger, level: :info

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
