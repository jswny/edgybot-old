import Config

config :edgybot, Edgybot.Repo,
  database: "edgybot_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
