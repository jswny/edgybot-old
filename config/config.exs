import Config

config :edgybot,
  ecto_repos: [Edgybot.Repo]

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  num_shards: :auto

import_config "#{Mix.env()}.exs"
