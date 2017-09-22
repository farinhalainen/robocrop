module State exposing (..)

import Types exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline


initModel: Model
initModel =
  { plants = Nothing
  , focusedPlant = Nothing
  , currentView = LoaderView
  , errorMessage = Nothing
  }


init : (Model, Cmd Msg)
init =
  (initModel, getLatestReading)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        PlantDataResponse result ->
            case result of
                Ok plants ->
                    (
                        { model | plants = Just plants
                        , currentView = PlantListView
                        }
                        , Cmd.none
                    )
                Err error ->
                    (
                        { model | errorMessage = Just "Something went wrong"}
                        , Cmd.none
                    )

        ShowPlantView plant ->
            (
                { model | currentView = PlantDetailView
                , focusedPlant = Just plant
                }
                , Cmd.none
            )

        ShowListView ->
            (
                { model | currentView = PlantListView
                , focusedPlant = Nothing
                }
                , Cmd.none
            )


getLatestReading : Cmd Msg
getLatestReading =
    Http.get "http://api.plants.sofiapoh.com/plants" mainDecoder
        |> Http.send PlantDataResponse

mainDecoder : Decoder (List Plant)
mainDecoder =
    Decode.field "plants" (Decode.list plantDecoder)

plantDecoder : Decoder Plant
plantDecoder =
   Pipeline.decode Plant
      |> Pipeline.required "id" Decode.int
      |> Pipeline.required "name" Decode.string
      |> Pipeline.required "latestValue" Decode.int
      |> Pipeline.required "latestReadingAt" Decode.string
      |> Pipeline.required "threshold" Decode.int

