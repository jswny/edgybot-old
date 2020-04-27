import Config

config :edgybot, Edgybot.Repo,
  database: "edgybot",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :edgybot, ecto_repos: [Edgybot.Repo]

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  num_shards: :auto
