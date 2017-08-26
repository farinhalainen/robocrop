module Update exposing (..)

import Types exposing (..)
import Http
import Json.Decode as Decode exposing (int, string, float, Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, optional, hardcoded)
import Random

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        HandlePlantDataResponse result ->
            case result of
                Ok result ->
                    ({ model | plants = result, currentView = PlantListView }, Cmd.none)
                Err error ->
                    ({ model | errorMessage = Just "Something went wrong"}, Cmd.none)
                    
        ShowPlantView plant ->
            ({model | currentView = PlantDetailView, focusedPlant = Just plant }, Cmd.none)

        ShowListView ->
            ({model | currentView = PlantListView, focusedPlant = Nothing }, Cmd.none)


getLatestReading : Cmd Msg
getLatestReading =
    Http.get "http://api.plants.sofiapoh.com/plants" mainDecoder
        |> Http.send HandlePlantDataResponse
 
mainDecoder : Decoder (List Plant)
mainDecoder =
    Decode.field "plants" (Decode.list plantDecoder)

plantDecoder : Decoder Plant
plantDecoder =
   decode Plant
      |> Pipeline.required "id" int
      |> Pipeline.required "name" string
      |> Pipeline.required "latestValue" int
      |> Pipeline.required "latestReadingAt" string
      |> Pipeline.required "threshold" int

