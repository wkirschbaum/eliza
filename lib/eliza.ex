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
    |> dbg

    {input, history}
  end

  defp extract_sentence(tokens, sentence \\ [], keywords \\ [])

  defp extract_sentence([], sentence, _keywords), do: Enum.reverse(sentence)

  defp extract_sentence([{:delimeter, _} | _tokens], sentence, keywords)
       when length(keywords) > 0 do
    Enum.reverse(sentence)
  end

  defp extract_sentence([{:delimeter, _} | tokens], _sentence, _keywords) do
    extract_sentence(tokens, [], [])
  end

  defp extract_sentence([{:noun, _val} = token | tokens], sentence, keywords) do
    extract_sentence(tokens, [token | sentence], keywords)
  end

  defp extract_sentence([token | tokens], sentence, keywords) do
    extract_sentence(tokens, [token | sentence], [token | keywords])
  end
end
