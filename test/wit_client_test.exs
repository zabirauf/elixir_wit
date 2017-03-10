defmodule WitClientTest do
  use ExUnit.Case
  require Logger

  alias Wit.Models.Context
  alias Wit.Models.Response.Converse
  alias Wit.Models.Response.Message
  alias Wit.Models.Response.Outcome

  setup do
    access_token = Application.get_env(:elixir_wit, :wit_credentials)[:server_access_token]
    {:ok, access_token: access_token}
  end

  test "Call message api", %{access_token: access_token} do
    timezone = "America/Los_Angeles"
    {:ok, message} = Wit.Client.message(access_token, "What is the weather in Seattle tomorrow", "", "", %{timezone: timezone}) |> Wit.Client.Deserializer.deserialize_message()

    assert !is_nil(message.entities)
    dt = message.entities["datetime"] |> Enum.at(0) |> Map.get("value") |> Timex.parse!("{ISO:Extended}")

    # Ends with either -07:00 or -08:00 for Los Angeles timezone (depending on DST and current time of year)
    assert Regex.match?(~r/-0[78]:00$/, DateTime.to_iso8601(dt))
  end

  test "Call converse api", %{access_token: access_token} do
    session_id = UUID.uuid1()
    {:ok, converse} = Wit.Client.converse(access_token, session_id, "What is the weather in Seattle", %{}) |> Wit.Client.Deserializer.deserialize_converse()

    assert converse.confidence > 0
    assert ["merge", "msg", "action", "stop"] |> Enum.member?(converse.type)
    assert !is_nil(converse.entities)
  end

end
