defmodule Eliza.Words do
  import NimbleParsec

  def parse(input) do
    case parse_words(input) do
      {:ok, tokens, "", _, _, _} ->
        tokens

      _ ->
        []
    end
  end

  words =
    File.read!(Path.join(__DIR__, "words.json"))
    |> Jason.decode!()

  delimiters =
    words["delimiters"]
    |> Enum.map(&string/1)

  greeting =
    words["greetings"]
    |> Enum.map(&string/1)

  pronouns =
    words["pronouns"]
    |> Enum.map(&string/1)

  verbs =
    words["verbs"]
    |> Enum.map(&string/1)

  word_chars = [?a..?z, ?A..?Z, ?0..?9, ?']

  words =
    empty()
    |> repeat(
      choice([
        ignore(string(" ")),
        choice(delimiters) |> tag(:delimiter),
        choice(greeting) |> lookahead_not(ascii_char(word_chars)) |> tag(:greeting),
        choice(pronouns) |> lookahead_not(ascii_char(word_chars)) |> tag(:pronouns),
        choice(verbs) |> lookahead_not(ascii_char(word_chars)) |> tag(:verbs),
        ascii_string(word_chars, min: 1) |> tag(:noun)
      ])
    )

  defparsecp(:parse_words, words)
end
