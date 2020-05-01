defmodule Edgybot.Bot.EventConsumer do
  use Nostrum.Consumer
  alias Nostrum.Api
  require Logger

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
    case message.guild_id do
      nil -> :ignore
      _ ->
        ping = prefixed_command("ping")

        case message.content do
          ^ping ->
            Api.create_message(message.channel_id, "Pong!")
          _ ->
            :ignore
        end
    end
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
end
