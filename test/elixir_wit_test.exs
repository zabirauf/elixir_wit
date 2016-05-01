defmodule WitTest do
  use ExUnit.Case
  require Logger
  doctest Wit

  test "RAND" do
    defmodule TestModule do
      def foo(bar) when bar in ["abc", "def"] do
        1
      end

      def foo(bar) do
        2
      end
    end

    assert 1 == TestModule.foo("abc")
    assert 2 == TestModule.foo("ghi")
  end
end
