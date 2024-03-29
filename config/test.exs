import Config

config :edgybot, Edgybot.Repo,
  database: "edgybot_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  show_sensitive_data_on_connection_error: true

config :logger, level: :warn
