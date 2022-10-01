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

  delimeter =
    [",", "!", "?", "."]
    |> Enum.map(&string/1)

  greeting =
    ["hi", "howzit", "hey"]
    |> Enum.map(&string/1)

  pronouns =
    ~w[
      i me mine myself
      we us ours ourselves ourself
      you yours yourself yourselves
      he him himself she hers herself
      it that those this these things thing
      they them themselves theirs
      anybody everybody somebody
      anyone everyone someone
      anything something everything
    ]
    |> Enum.map(&string/1)

  verbs =
    ~w[
      abort aborted aborts ask asked asks am
      applied applies apply are associate
      associated ate
      be became become becomes becoming
      been being believe believed believes
      bit bite bites bore bored bores boring bought buy buys buying
      call called calling calls came can caught catch come
      contract contracted contracts control controlled controls
      could croak croaks croaked cut cuts
      dare dared define defines dial dialed dials did die died dies
      dislike disliked
      dislikes do does drank drink drinks drinking
        drive drives driving drove dying
        eat eating eats expand expanded expands
        expect expected expects expel expels expelled
        explain explained explains
        fart farts feel feels felt fight fights find finds finding
        forget forgets forgot fought found
        fuck fucked fucking fucks
        gave get gets getting give gives go goes going gone got gotten
        had harm harms has hate hated hates have having
        hear heard hears hearing help helped helping helps
        hit hits hope hoped hopes hurt hurts
        implies imply is
        join joined joins jump jumped jumps
        keep keeping keeps kept
        kill killed killing kills kiss kissed kisses kissing
        knew know knows
        laid lay lays let lets lie lied lies like liked likes
        liking listen listens
        login look looked looking looks
        lose losing lost
        love loved loves loving
        luse lusing lust lusts
        made make makes making may mean means meant might
        move moved moves moving must
        need needed needs
        order ordered orders ought
        paid pay pays pick picked picking picks
        placed placing prefer prefers put puts
        ran rape raped rapes
        read reading reads recall receive received receives
        refer refered referred refers
        relate related relates remember remembered remembers
        romp romped romps run running runs
        said sang sat saw say says
        screw screwed screwing screws scrod see sees seem seemed
        seems seen sell selling sells
        send sendind sends sent shall shoot shot should
        sing sings sit sits sitting sold studied study
        take takes taking talk talked talking talks tell tells telling
        think thinks
        thought told took tooled touch touched touches touching
        transfer transferred transfers transmit transmits transmitted
        type types types typing
        walk walked walking walks want wanted wants was watch
        watched watching went were will wish would work worked works
        write writes writing wrote use used uses using
  ]
    |> Enum.map(&string/1)

  word_chars = [?a..?z, ?A..?Z, ?0..?9]

  words =
    empty()
    |> repeat(
      choice([
        ignore(string(" ")),
        choice(delimeter) |> tag(:delimeter),
        choice(greeting) |> lookahead_not(ascii_char(word_chars)) |> tag(:greeting),
        choice(pronouns) |> lookahead_not(ascii_char(word_chars)) |> tag(:pronouns),
        choice(verbs) |> lookahead_not(ascii_char(word_chars)) |> tag(:verbs),
        ascii_string(word_chars, min: 1) |> tag(:noun),
      ])
    )


    defparsecp(:parse_words, words)
end
