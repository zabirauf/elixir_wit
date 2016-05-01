defmodule Wit.Models.Context do
  defstruct state: [], reference_time: "", timezone: "", entities: [], location: nil
end

defmodule Wit.Models.Response.Message do
  defstruct msg_id: "", _text: "", outcomes:[]
end

defmodule Wit.Models.Response.Outcome do
  defstruct _text: "", intent: "", entities: [], confidence: 0
end
