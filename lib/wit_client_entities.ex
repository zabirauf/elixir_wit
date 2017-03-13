defmodule Wit.Client.Entities do
  require Logger
  import Wit.Client, only: [create_url: 1, headers: 1]

  @endpoint "https://api.wit.ai"
  @api_entities "#{@endpoint}/entities"

  @type response_type :: {:ok, map} | {:error, String.t, map}

  @spec get(String.t) :: response_type
  def get(access_token) do
    create_url(@api_entities)
    |> HTTPotion.get([headers: headers(access_token)])
    |> deserialize
  end

  @spec get(String.t, String.t) :: response_type
  def get(access_token, entity_name) do
    create_url("#{@api_entities}/#{entity_name}")
    |> HTTPotion.get([headers: headers(access_token)])
    |> deserialize
  end

  @spec create(String.t, map) :: response_type
  def create(access_token, %{"id" => _} = entity) do
    body_stringified = Poison.encode!(entity)

    create_url(@api_entities)
    |> HTTPotion.post([body: body_stringified, headers: headers(access_token)])
    |> deserialize
  end

  @spec update(String.t, String.t, map) :: response_type
  def update(access_token, entity_name, entity) do
    body_stringified = Poison.encode!(entity)

    create_url("#{@api_entities}/#{entity_name}")
    |> HTTPotion.put([body: body_stringified, headers: headers(access_token)])
    |> deserialize
  end

  @spec delete(String.t, String.t) :: response_type
  def delete(access_token, entity_name) do
    create_url("#{@api_entities}/#{entity_name}")
    |> HTTPotion.delete([headers: headers(access_token)])
    |> deserialize
  end

  @spec create_value(String.t, String.t, map) :: response_type
  def create_value(access_token, entity_name, %{"value" => _} = value) do
    body_stringified = Poison.encode!(value)

    create_url("#{@api_entities}/#{entity_name}/values")
    |> HTTPotion.post([body: body_stringified, headers: headers(access_token)])
    |> deserialize
  end

  @spec delete_value(String.t, String.t, map) :: response_type
  def delete_value(access_token, entity_name, entity_value) do
    create_url("#{@api_entities}/#{entity_name}/values/#{entity_value}")
    |> HTTPotion.delete([headers: headers(access_token)])
    |> deserialize
  end

  @spec create_expression(String.t, String.t, String.t, map) :: response_type
  def create_expression(access_token, entity_name, entity_value, %{"expression" => _} = expression) do
    body_stringified = Poison.encode!(expression)

    create_url("#{@api_entities}/#{entity_name}/values/#{entity_value}/expressions")
    |> HTTPotion.post([body: body_stringified, headers: headers(access_token)])
    |> deserialize
  end

  @spec delete_expression(String.t, String.t, String.t, String.t) :: response_type
  def delete_expression(access_token, entity_name, entity_value, expression_value) do
    create_url("#{@api_entities}/#{entity_name}/values/#{entity_value}/expressions/#{expression_value}")
    |> HTTPotion.delete([headers: headers(access_token)])
    |> deserialize
  end

  @doc """
  Deserialize the response
  """
  @spec deserialize(map) :: {:ok, map} | {:error, String.t, map}
  def deserialize(%HTTPotion.Response{status_code: 200} = resp) do
    {:ok, Poison.decode!(resp.body)}
  end

  def deserialize(%HTTPotion.Response{status_code: code} = resp) do
    Logger.debug inspect(resp)
    {:error, "Invalid status code #{code}", resp}
  end

end
