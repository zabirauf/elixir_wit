defmodule WitActionsTest do
  use ExUnit.Case
  require Logger
  doctest Wit

  test "The custom action creation using defaction macro" do

    quoted_func = quote do
      defaction fetch_weather(session, context, callback) do
        Logger.info "Fetching weather"
        assert true
      end
    end

    module_code = create_custom_action(quoted_func)
    Code.eval_quoted(module_code)

    CustomActions.call_action("fetch_weather", nil, nil, nil)
  end

  test "Calling Say action" do

    quoted_func = quote do
      defaction fetch_weather(session, context, callback) do
        Logger.info "Fetching weather"
        assert false
      end
    end

    module_code = create_custom_action(quoted_func, true)
    Code.eval_quoted(module_code)

    CustomActions.call_action("say", nil, nil, nil, nil)
  end

  defp create_custom_action(code, say_result \\ false, merge_result \\ false, error_result \\ false) do
    quote do
      defmodule CustomActions do
        use Wit.Actions
        require Logger

        def say(session, context, message, callback) do
          Logger.info "Called Say"
          assert unquote(say_result)
        end

        def merge(session, context, message, callback) do
          Logger.info "Called Merge"
          assert unquote(merge_result)
        end

        def error(session, context, callback) do
          Logger.info "Called Error"
          assert unquote(error_result)
        end

        unquote(code)
      end
    end
  end

end
