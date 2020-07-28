defmodule Edgybot.Core do
  alias Edgybot.Repo
  alias Edgybot.Core.{Mock}

  def create_mock(attrs \\ %{}) do
    %Mock{}
    |> Mock.changeset(attrs)
    |> Repo.insert()
  end
end
