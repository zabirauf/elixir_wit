defmodule Wit.DefaultActions do
  @moduledoc """
  Callbacks to the default actions for the WIT
  """

  @doc """
  Called when the converse API has type `{type: "msg"}`.
  This should send message back to the user.
  """
  @callback say(String.t, map, String.t) :: any

  @doc """
  Called when the converse API has type `{type: "merge"}`.
  This should update the context with the information provided in the request
  """
  @callback merge(String.t, map, map) :: map


  @callback error(String.t, map, any) :: map
end
