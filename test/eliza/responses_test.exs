defmodule Eliza.ResponsesTest do
  use ExUnit.Case

  test "random text" do
    IO.puts(Eliza.Responses.random())
  end
end
