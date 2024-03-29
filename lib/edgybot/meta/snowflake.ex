defmodule Edgybot.Meta.Snowflake do
  import Ecto.Changeset
  require Nostrum.Snowflake

  def validate_snowflake(changeset, field) when is_atom(field) do
    validate_change(changeset, field, fn (_current_field, value) ->
      if !Nostrum.Snowflake.is_snowflake(value) do
        [{field, "invalid snowflake"}]
      else
        []
      end
    end)
  end
end
