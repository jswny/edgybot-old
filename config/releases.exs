import Config

import Config

discord_token =
  System.get_env("DISCORD_TOKEN") ||
    raise """
    environment variable DISCORD_TOKEN is missing.
    """

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :edgybot, Edgybot.Repo,
  url: database_url

config :nostrum,
  token: discord_token
