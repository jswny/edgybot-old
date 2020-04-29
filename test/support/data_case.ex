defmodule Edgybot.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Edgybot.Repo

      import Ecto
      import Ecto.Query
      import Edgybot.DataCase

      import Edgybot.Meta.ServerFixtures
      import Edgybot.Meta.ChannelFixtures
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Edgybot.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Edgybot.Repo, {:shared, self()})
    end

    :ok
  end
end
