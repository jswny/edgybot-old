defmodule Edgybot.Bot.EventConsumer do
  require Logger
  alias Edgybot.Meta
  alias Edgybot.Core
  use Nostrum.Consumer
  alias Nostrum.Api

  def start_link() do
    Consumer.start_link(__MODULE__)
  end

  def child_spec(args) do
    id = "event_consumer_thread_#{args[:thread_number]}"
    %{
      id: id,
      start: {__MODULE__, :start_link, []}
    }
  end

  @impl true
  def handle_event({:MESSAGE_CREATE, message, _ws_state}) do
    event_type = :MESSAGE_CREATE
    Logger.debug("Received event: #{event_type}")

    # Don't respond to PMs
    # Channels would have to understand PM channels if PMs are to be handled
    handle_message_create(message.guild_id, message)
  end

  # Default handler to handle all unhandled events.
  @impl true
  def handle_event(event) do
    event_type = elem(event, 0)
    Logger.debug("Ignored event: #{event_type}")
    :noop
  end

  defp command_prefix() do
    Application.get_env(:edgybot, :command_prefix)
  end

  defp prefixed_command(command) do
    "#{command_prefix()} #{command}"
  end

  defp handle_message_create(nil, message) when is_struct(message), do: :ignore
  defp handle_message_create(_guild_id, message) when is_struct(message) do
    ping = prefixed_command("ping")
    mock_add = prefixed_command("mock add")

    channel_id = message.channel_id

    case message.content do
      ^ping ->
        Api.create_message(channel_id, "Pong!")
      ^mock_add ->
        mentioned_users = message.mentions
        mentioned_users_count = Enum.count(mentioned_users)

        if mentioned_users_count != 1 do
          Api.create_message(channel_id, "Command #{mock_add} requires 1 mention only, but #{mentioned_users_count} mentioned!")
        else
          ensure_exists_from_message(message)
        end
      _ ->
        :ignore
    end
  end

  defp ensure_exists_from_message(message) when is_struct(message) do
    server_snowflake = message.guild_id
    channel_snowflake = message.channel_id

    author_user_snowflake = message.author.id
    author_member_attrs = message.member

    mentioned_user_snowflakes = Enum.map(message.mentions, fn user -> user.id end)

    # TODO: Fix ensure function to take user snowflakes, and get member from API, or use member attrs if provided

    Meta.ensure_exists(
      server_snowflake: server_snowflake,
      channel_snowflake: channel_snowflake
    )
  end
end
