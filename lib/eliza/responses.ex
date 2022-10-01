defmodule Eliza.Responses do
  import NimbleParsec

  phrase =
    choice([string("I am"), string("You must be")])
    |> string(" ")
    |> choice([string("sad"), string("happy"), string("stressed")])

  defparsec(:parse, phrase, export_metadata: true)

  def random() do
    NimbleParsec.parsec({Eliza.Responses, :parse})
    |> NimbleParsec.generate()
  end
end
