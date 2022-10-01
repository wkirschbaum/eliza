defmodule Eliza do
  @moduledoc """
  Documentation for `Eliza`.

  Spec from http://www.universelle-automation.de/1966_Boston.pdf
  """

  def consult(input, history) do
    output =
      input
      |> String.downcase()
      |> Eliza.Words.parse()
      |> extract_sentence()
      |> transform()
      |> random_question
      |> capitalize_sentence
      |> to_response()

    {input, output, history}
  end

  defp random_question({words, _keywords}) do
    first_noun =
      Enum.filter(words, fn
        {:noun, _word} -> true
        _ -> false
      end)
      |> Enum.random()

    words =
      case first_noun do
        nil -> Enum.map(words, fn {_, word} -> word end)
        {_, word} -> word
      end

    [
      [] ++ words ++ ["?"],
      ["what do yo mean by"] ++ words ++ ["?"],
      ["tell me more about"] ++ words ++ ["?"],
      ["is it because of"] ++ words ++ ["that you come to me?"]
    ]
    |> Enum.random()
  end

  defp get_token(tokens) do
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

  defp transform({[], keywords}, results), do: {Enum.reverse(results), keywords}

  defp transform({[{type, [val]} | words], keywords}, results) do
    new_word =
      case val do
        "i" -> "you"
        "you" -> "I"
        "your" -> "my"
        "mine" -> "yours"
        "are" -> "am"
        other -> other
      end

    transform({words, keywords}, [{type, [new_word]} | results])
  end

  defp extract_sentence(tokens, sentence \\ [], keywords \\ [])

  defp extract_sentence([], sentence, keywords),
    do: {Enum.reverse(sentence), Enum.reverse(keywords)}

  defp extract_sentence([{:delimiter, _} | _tokens], sentence, keywords)
       when length(keywords) > 0 do
    {Enum.reverse(sentence), Enum.reverse(keywords)}
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
