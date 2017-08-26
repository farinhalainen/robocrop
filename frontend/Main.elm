module Main exposing (..)

import Update exposing (..)
import Types exposing (..)
import View exposing (..)
import Html exposing (..)
import Styles exposing (..)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = (\_ -> Sub.none)
    }

initModel: Model
initModel =
  {
    plants =
      [
        { id = 0
        , name = "Blob"
        , latestValue = 0
        , latestReadingAt = "2017-08-12T22:30:18.800Z"
        , threshold = 0
        }
      ]
    , currentView = LoaderView
    , errorMessage = Nothing
    , focusedPlant = Nothing
  }

init : (Model, Cmd Msg)
init =
  (initModel, getLatestReading)
