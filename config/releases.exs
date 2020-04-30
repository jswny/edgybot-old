import Config

get_env_var = fn (var_name) ->
  var = System.get_env(var_name)
  if var == nil || var == "" do
    raise """
    environment variable #{var_name} is missing.
    """
  else
    var
  end
end

config :edgybot,
  command_prefix: get_env_var.("COMMAND_PREFIX")

config :edgybot, Edgybot.Repo,
  url: get_env_var.("DATABASE_URL")

config :nostrum,
  token: get_env_var.("DISCORD_TOKEN")
