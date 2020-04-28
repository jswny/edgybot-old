import Config

config :edgybot, Edgybot.Repo,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
