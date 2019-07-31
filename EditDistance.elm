module EditDistance exposing (levenshtein, levenshteinOfStrings)

import Array exposing (Array)

{-| Algorithms for edit distance calculation.


# Levenshtein distance

@docs levenshtein, levenshteinOfStrings

-}


min3 : comparable -> comparable -> comparable -> comparable
min3 a b c =
    if a <= b && a <= c then
        a

    else if b <= c then
        b

    else
        c

patternLoop : comparable -> List comparable -> Int -> Int -> Int -> Int -> Array Int -> Array Int
patternLoop textHead pattern idx b0 b1 b2 col =
    case pattern of
        patternHead :: patternTail ->
            let
                b0_ : Int
                b0_ =
                    b1

                b1_ : Int
                b1_ =
                    Maybe.withDefault b0_ (Array.get (idx + 1) col)

                b2_ : Int
                b2_ =
                    if textHead == patternHead then
                        b0

                    else
                        1 + min3 b0 b1 b2

                updateCol : Array Int
                updateCol =
                    Array.set idx b2_ col

            in
            patternLoop textHead patternTail (idx + 1) b0_ b1_ b2_ updateCol

        [] ->
            col


textLoop : List comparable -> List comparable -> Int -> Array Int -> Array Int
textLoop text pattern idx col =
    case text of
        textHead :: textTail ->
            let
                b0 : Int
                b0 =
                    idx

                b1 : Int
                b1 =
                    Maybe.withDefault -1 (Array.get 0 col)

                b2 : Int
                b2 =
                    idx + 1

                updateCol : Array Int
                updateCol =
                    patternLoop textHead pattern 0 b0 b1 b2 col

            in
            textLoop textTail pattern (idx + 1) updateCol

        [] ->
            col


{-| Finds the [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance)
between two `List comparable` in `O(mn)`.

    kitten = String.toList "kitten"
    sitten = String.toList "sitten"
    sittin = String.toList "sittin"
    sitting = String.toList "sitting"

    levenshtein kitten sitten == 1
    levenshtein sitten sittin == 1
    levenshtein sittin sitting == 1

-}
levenshtein : List comparable -> List comparable -> Int
levenshtein text pattern =
    case ( text, pattern ) of
        ( [], _ ) ->
            List.length pattern

        ( _, [] ) ->
            List.length text

        ( [ textHead ], _ ) ->
            if List.any ((==) textHead) pattern then
                List.length pattern - 1

            else
                List.length pattern

        ( _, [ patternHead ] ) ->
            if List.any ((==) patternHead) text then
                List.length text - 1

            else
                List.length text

        ( textHead :: textTail, patternHead :: patternTail ) ->
            if textHead == patternHead then
                levenshtein textTail patternTail

            else
                let
                    patternLen : Int
                    patternLen =
                        List.length pattern

                    initCol : Array Int
                    initCol =
                        Array.initialize patternLen (\x -> x + 1)
                in
                textLoop text pattern 0 initCol
                    |> Array.get (patternLen - 1)
                    |> Maybe.withDefault -1


{-| Like [levenshtein](#levenshtein), but takes two `String` as input.
-}
levenshteinOfStrings : String -> String -> Int
levenshteinOfStrings text pattern =
    if String.length pattern > String.length text then
        levenshteinOfStrings pattern text

    else
        levenshtein (String.toList text) (String.toList pattern)
