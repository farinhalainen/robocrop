module Main exposing (main)

{-|Entry point

@docs main
-}

import Html
import State exposing (init, update)
import Types exposing (Model, Msg)
import View exposing (view)


{-| Run the application
-}
main: Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = (\_ -> Sub.none)
    }
