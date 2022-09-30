defmodule ElizaTest do
  use ExUnit.Case
  doctest Eliza

  test "greets the world" do
    assert Eliza.hello() == :world
  end
end
