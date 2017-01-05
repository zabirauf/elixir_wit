defmodule Wit.Client do
  require Logger

  @endpoint "https://api.wit.ai"
  @version "20160330"

  @api_converse "#{@endpoint}/converse"
  def converse(access_token, session_id, text \\ "", context \\ %{}, version \\ @version) do
    get_params = %{"v" => version, "session_id" => session_id, "q" => URI.encode(text)}
    converse_api = create_url("#{@api_converse}?", get_params)

    body_stringified = Poison.encode!(context)
    Logger.debug "Calling API #{converse_api} \n #{body_stringified}"

    HTTPotion.post(converse_api, [body: body_stringified, headers: headers(access_token)])
  end

  @api_message "#{@endpoint}/message"
  def message(access_token, text, thread_id \\ "", msg_id \\ "", context \\ %{}, total_outcomes \\ 1, version \\ @version) do
    context_stringified = context |> Poison.encode! |> URI.encode
    get_params = %{
      "v" => version,
      "q" => URI.encode(text),
      "thread_id" => thread_id,
      "msg_id" => msg_id,
      "n" => total_outcomes,
      "context" => context_stringified
    }

    message_api = create_url("#{@api_message}?", get_params)
    HTTPotion.get(message_api, [headers: headers(access_token)])
  end

  def create_url(endpoint), do: create_url(endpoint, %{})
  def create_url(endpoint, %{} = get_params) do
    Map.keys(get_params)
    |> Enum.reduce(endpoint, fn(key, url) ->
      append_to_url(url, key, Map.get(get_params, key))
    end)
  end

  def headers(access_token) do
    [
      "Authorization": "Bearer #{access_token}",
      "Content-Type": "application/json",
      "Accept": "application/json"
    ]
  end

  defp append_to_url(url, _key, ""), do: url
  defp append_to_url(url, key, param), do: "#{url}&#{key}=#{param}"
end

defmodule Wit.Client.Deserializer do
  @moduledoc """
  The deserializer for the response of the WIT API.
  """
  require Logger

  @doc """
  Deserialize the response from the /converse API
  """
  @spec deserialize_converse(map) :: {:ok, map} | {:error, String.t, map}
  def deserialize_converse(%HTTPotion.Response{status_code: 200} = resp) do
    {:ok, Poison.decode!(resp.body, as: %Wit.Models.Response.Converse{})}
  end
  def deserialize_converse(%HTTPotion.Response{status_code: code} = resp) do
    Logger.debug inspect(resp)
    {:error, "Invalid status code #{code}", resp}
  end

  @doc """
  Deserialize the response from the /message API
  """
  @spec deserialize_message(map) :: {:ok, map} | {:error, String.t, map}
  def deserialize_message(%HTTPotion.Response{status_code: 200} = resp) do
    {:ok, Poison.decode!(resp.body, as: %Wit.Models.Response.Message{outcomes: [%Wit.Models.Response.Outcome{}]})}
  end
  def deserialize_message(%HTTPotion.Response{status_code: code} = resp) do
    Logger.debug inspect(resp)
    {:error, "Invalid status code #{code}", resp}
  end

end
