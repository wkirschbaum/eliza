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

  test "random text" do
    [
      "I haven't heard of these commands, let me try them",
      "What is your name?",
      "Hi there good people, I was wondering how do you guys manage growing number of migration files"
    ]
    |> Enum.each(fn text ->
      IO.inspect(Eliza.consult(text, []))
    end)
  end
end
