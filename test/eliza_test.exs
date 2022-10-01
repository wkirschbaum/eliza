defmodule ElizaTest do
  use ExUnit.Case
  doctest Eliza

  test "Say hi" do
    state = []

    IO.inspect(Eliza.consult("Hi, how are you Eliza!", state))
    IO.inspect(Eliza.consult("I saw a movie", state))
    IO.inspect(Eliza.consult("What are you up to?", state))
    IO.inspect(Eliza.consult("Wilhelm, jump into the ocean", state))
  end
end
