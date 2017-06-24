# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :ui, Ui.Endpoint,
  http: [port: 80],
  url: [host: "localhost", port: 80],
  secret_key_base: "Qhn3WWE/JmVioyGUW5dIo2f4p592ZbldCK4GrhKMqcpfk/JU3MAxvv8SaSpSfGlN",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub],
  code_reload: false

config :logger, level: :debug

config :fw, :wlan0,
  ssid: System.get_env("NERVES_WIFI_SSID"),
  key_mgmt: :"WPA-PSK",
  psk: System.get_env("NERVES_WIFI_PSK")

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.

# config :nerves, :firmware,
#   rootfs_additions: "config/rootfs_additions",
#   fwup_conf: "config/fwup.conf"

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
