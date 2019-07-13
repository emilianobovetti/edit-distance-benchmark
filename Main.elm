port module Main exposing (main)

import EditDistance exposing (levenshteinOfStrings)

type alias Msg =
    { text : String
    , pattern : String
    }

type alias Model =
    ()

port sendDistance : Int -> Cmd msg

port calcDistance : (Msg -> msg) -> Sub msg

update { text, pattern } _ =
    ( (), sendDistance (levenshteinOfStrings text pattern) )


main : Program () Model Msg
main =
    Platform.worker
        { init = \_ -> ( (), Cmd.none )
        , update = update
        , subscriptions = \() -> calcDistance identity
        }
