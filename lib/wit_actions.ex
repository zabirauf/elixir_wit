defmodule Wit.Actions do

  defmacro __using__(_opts) do
    quote do
      require Wit.Actions
      import Wit.Actions

      @behaviour Wit.DefaultActions

      @wit_actions %{"say" => :say, "merge" => :merge, "error" => :error}

      @before_compile Wit.Actions
    end
  end

  @doc """
  Defines a wit custom action

  ## Examples

      defaction fetch_weather(session, context, callback) do
        # Fetch weather
        callback.()
      end
  """
  defmacro defaction(head, body) do
    {func_name, arg_list} = Macro.decompose_call(head)

    # Throw error if the argument list is not equal to 3
    if length(arg_list) != 3 do
      raise ArgumentError, message: "Wit action should have three arguments i.e. session, context, callback"
    end

    quote do
      @wit_actions Map.put(@wit_actions, unquote(Atom.to_string(func_name)), unquote(func_name))

      def unquote(head) do
        unquote(body)
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do

      def actions() do
        @wit_actions
      end
      def call_action(action, session, context, message, callback) when action in ["say", "merge"] do
        call_action(action, [session, context, message, callback])
      end

      def call_action(action, session, context, callback) do
        call_action(action, [session, context, callback])
      end

      defp call_action(action, arg_list) do
        wit_actions = @wit_actions
        func = Map.get(wit_actions, action)

        if func == nil do
          {:error, "No action #{action} found"}
        end

        apply(__MODULE__, func, arg_list)
      end
    end
  end
end
