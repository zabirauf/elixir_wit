defmodule Wit.Models.Response.Converse do
  @moduledoc """
  The response for the /converse WIT API
  """

  @type t :: %{type: String.t, msg: String.t, action: any, entities: [map()], confidence: float}
  defstruct type: "", msg: nil, action: nil, entities: [], confidence: 0
end

defmodule Wit.Models.Response.Outcome do
  @moduledoc """
  The outcomes contained in the response of the /message WIT API
  """

  @type t :: %{_text: String.t, intent: String.t, entities: [map()], confidence: float}
  defstruct _text: "", intent: "", entities: [], confidence: 0
end

defmodule Wit.Models.Response.Message do
  @moduledoc """
  The response for the /message WIT API
  """

  alias Wit.Models.Response.Outcome

  @type t :: %{msg_id: String.t, _text: String.t, outcomes: [Outcome.t]}
  defstruct msg_id: "", _text: "", outcomes: []
end
