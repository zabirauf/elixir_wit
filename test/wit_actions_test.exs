defmodule WitActionsTest do
  use ExUnit.Case
  require Logger
  doctest Wit.Actions

  @access_token ""

  test "The custom action creation using defaction macro" do

    quoted_func = quote do
      defaction fetch_weather(session, context) do
        Logger.info "Fetching weather"
        assert true
        context
      end
    end

    module_code = create_custom_action(quoted_func)
    Code.eval_quoted(module_code)

    CustomActions.call_action("fetch_weather", nil, nil)
  end

  test "Calling Say action" do

    quoted_func = quote do
      defaction fetch_weather(session, context) do
        Logger.info "Fetching weather"
        assert false
        context
      end
    end

    module_code = create_custom_action(quoted_func, true)
    Code.eval_quoted(module_code)

    CustomActions.call_action("say", nil, nil, nil)
  end

  test "Running action" do

    defmodule CustomActions do
      use Wit.Actions
      require Logger

      def say(_session, context, message) do
        Logger.info "Say..."
        Logger.info inspect(message)
        Logger.info inspect(context)
      end

      def merge(_session, context, message) do
        Logger.info "Merge..."
        Logger.info inspect(message)
        Logger.info inspect(context)

        if(Map.has_key?(message.entities, "location")) do
          [location | _] = message.entities["location"]
          context = Map.put(context, "loc", location["value"])
        end

        context
      end

      def error(_session, context, _error) do
        Logger.info "Error..."
        Logger.info inspect(context)
      end

      defaction fetch_weather(_session, context) do
        Logger.info "Fetch weather..."
        Logger.info inspect(context)

        Map.put(context, "forecast", "Sunny")
      end
    end

    session_id = UUID.uuid1()
    assert {:ok, context}= Wit.run_actions(@access_token, session_id, CustomActions, "What is the weather?")
    assert {:ok, _} = Wit.run_actions(@access_token, session_id, CustomActions, "Seattle", context, 10)
  end

  @tag disabled: true
  test "Running interactive" do

    defmodule CustomActions do
      use Wit.Actions
      require Logger

      def say(_session, context, message) do
        IO.puts "> #{message.msg}"
      end

      def merge(_session, context, message) do
        Logger.info "Merge..."
        Logger.info inspect(message)
        Logger.info inspect(context)

        if(Map.has_key?(message.entities, "location")) do
          [location | _] = message.entities["location"]
          context = Map.put(context, "loc", location["value"])
        end

        context
      end

      def error(_session, context, _error) do
        Logger.info "Error..."
        Logger.info inspect(context)
      end

      defaction fetch_weather(_session, context) do
        Logger.info "Fetch weather..."
        Logger.info inspect(context)

        Map.put(context, "forecast", "Sunny")
      end
    end

    session_id = UUID.uuid1()
    assert {:ok, context}= Wit.interactive(@access_token, session_id, CustomActions)
  end


  defp create_custom_action(code, say_result \\ false, merge_result \\ false, error_result \\ false) do
    quote do
      defmodule CustomActions do
        use Wit.Actions
        require Logger

        def say(session, context, message) do
          Logger.info "Called Say"
          assert unquote(say_result)
        end

        def merge(session, context, message) do
          Logger.info "Called Merge"
          assert unquote(merge_result)
          context
        end

        def error(session, context, error) do
          Logger.info "Called Error"
          assert unquote(error_result)
        end

        unquote(code)
      end
    end
  end

end
