defmodule Edgybot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger
  alias EventConsumer

  def start(_type, _args) do
    # Starts a worker by calling: Edgybot.Worker.start_link(arg)
    # {Edgybot.Worker, arg}
    children = generate_event_consumer_children()
    children = children ++ [
      Edgybot.Repo
    ]

    prefix = Application.get_env(:edgybot, :command_prefix)
    Logger.info("Listening to prefix #{prefix}")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Edgybot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp generate_event_consumer_children() do
    # Generate one child ber thread
    Enum.map(1..System.schedulers_online(), fn thread_number ->
      {EventConsumer, [thread_number: thread_number]}
    end)
  end
end
