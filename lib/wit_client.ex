defmodule Wit.Client do
  alias Wit.Models.Context

  @endpoint "https://api.wit.ai"
  @version "20160330"

  @api "#{@endpoint}/converse"
  def converse(access_token, session_id, text \\ "", context \\ %{}, version \\ @version) do
    converse_api = "#{@api}?v=#{version}&session_id=#{session_id}&q=#{URI.encode(text)}"
    HTTPoison.post(converse_api, [body: Poison.encode(context), headers: headers(access_token)])
  end

  @api "#{@endpoint}/message"
  def message(access_token, text, thread_id \\ "", msg_id \\ "", context \\ %{}, total_outcomes \\ 1, version \\ @version) do
    context_stringified = context |> Poison.encode |> URI.encode
    message_api = "#{@api}?v=#{version}&q=#{URI.encode(text)}&thread_id=#{thread_id}&msg_id=#{msg_id}&n=#{total_outcomes}&context=#{context_stringified}"

    HTTPoison.get(message_api, [headers: headers(access_token)])
  end

  defp headers(access_token) do
    [
      "Authorization": "Bearer #{access_token}",
      "Content-Type": "application/json",
      "Accept": "application/json"
    ]
  end

end

defmodule Wit.Client.Deserializer do
  def deserialize_message(resp) do
    message = Poison.decode!(resp, as: %Wit.Models.Response.Message)
    outcomes = Enum.map(message.outcomes, &(struct(Wit.Models.Response.Outcome, &1)))

    Map.update(message, :outcomes, outcomes)
  end
end
