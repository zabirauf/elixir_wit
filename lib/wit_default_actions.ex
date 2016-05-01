defmodule Wit.DefaultActions do
  @callback say(String.t, Map.t, String.t, any) :: any
  @callback merge(String.t, Map.t, Map.t, any) :: any
  @callback error(String.t, Map.t, any) :: any
end
