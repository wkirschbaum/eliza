defmodule Eliza do
  @moduledoc """
  Documentation for `Eliza`.

  Spec from http://www.universelle-automation.de/1966_Boston.pdf
  """

  def consult(input, history) do
    input
    |> String.downcase()
    |> Eliza.Words.parse()
    |> extract_sentence()
    |> transform()
    |> random_question
    |> capitalize_sentence
    |> to_response()
    |> dbg

    {input, history}
  end

  defp random_question(words) do
    [
      [] ++ words ++ ["?"]
    ]
    |> Enum.random()
  end

  defp to_response(words) do
    words
    |> Enum.join(" ")
    |> String.replace(~r/ [\?\.]/, "?")
  end

  defp capitalize_sentence([]), do: []

  defp capitalize_sentence([word | words]) do
    [String.capitalize(word) | words]
  end

  defp transform(words, results \\ [])

  defp transform([], results), do: Enum.reverse(results)

  defp transform([{_, [word]} | words], results) do
    new_word =
      case word do
        "i" -> "you"
        "you" -> "I"
        "mine" -> "yours"
        "are" -> "am"
        other -> other
      end

    transform(words, [new_word | results])
  end

  defp extract_sentence(tokens, sentence \\ [], keywords \\ [])

  defp extract_sentence([], sentence, _keywords), do: Enum.reverse(sentence)

  defp extract_sentence([{:delimiter, _} | _tokens], sentence, keywords)
       when length(keywords) > 0 do
    Enum.reverse(sentence)
  end

  defp extract_sentence([{:delimiter, _} | tokens], _sentence, _keywords) do
    extract_sentence(tokens, [], [])
  end

  defp extract_sentence([{:noun, _val} = token | tokens], sentence, keywords) do
    extract_sentence(tokens, [token | sentence], keywords)
  end

  defp extract_sentence([token | tokens], sentence, keywords) do
    extract_sentence(tokens, [token | sentence], [token | keywords])
  end
end
