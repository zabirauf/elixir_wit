defmodule WitClientTest do
  use ExUnit.Case
  require Logger

  alias Wit.Models.Context
  alias Wit.Models.Response.Converse
  alias Wit.Models.Response.Message
  alias Wit.Models.Response.Outcome

  @access_token ""

  test "Call converse api" do
    session_id = UUID.uuid1()
    resp = Wit.Client.converse(@access_token, session_id, "What is the weather in Seattle", %{})
    Logger.info inspect(resp)

    {:ok, converse} = (resp |> Wit.Client.Deserializer.deserialize_converse)
    Logger.info inspect(converse)

    assert 1 == converse.confidence
    assert "merge" == converse.type
  end

end
