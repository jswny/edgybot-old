defmodule Edgybot.TestUtils do
  def random_string(), do: random_string_with_length(10)

  def random_number(), do: random_number_with_max(1_000_000)

  def random_discriminator() do
    0..3
    |> Enum.map(fn _digit -> random_number_with_max(9) end)
    |> List.to_string()
  end

  defp random_string_with_length(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
  end

  defp random_number_with_max(max) do
    :rand.uniform(max)
  end
end
