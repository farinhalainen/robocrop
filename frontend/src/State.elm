module State exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Types exposing (..)


initModel : Model
initModel =
    { plants = Nothing
    , currentView = LoaderView
    , focusedPlantId = Nothing
    , focusedPlantReadings = Nothing
    , errorMessage = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, getLatestReading )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlantDataResponse result ->
            case result of
                Ok plants ->
                    ( { model
                        | plants = Just plants
                        , currentView = PlantListView
                      }
                    , Cmd.none
                    )

                Err error ->
                    ( { model | errorMessage = Just (toString error) }
                    , Cmd.none
                    )

        SetFocusedPlant plantId ->
            case Just plantId == model.focusedPlantId of
                True ->
                    ( { model
                        | focusedPlantId = Nothing
                        , focusedPlantReadings = Nothing
                      }
                    , Cmd.none
                    )

                False ->
                    ( { model
                        | focusedPlantId = Just plantId
                        , focusedPlantReadings = Nothing
                      }
                    , getTimelineReadingIfNewFocus model plantId
                    )

        ShowListView ->
            ( { model
                | focusedPlantId = Nothing
              }
            , Cmd.none
            )

        PlantSeriesResponse result ->
            case result of
                Ok readings ->
                    ( { model | focusedPlantReadings = Just readings }, Cmd.none )

                Err error ->
                    ( { model | errorMessage = Just (toString error) }, Cmd.none )


getLatestReading : Cmd Msg
getLatestReading =
    Http.get "https://api.plants.sofiapoh.com/plants" mainDecoder
        |> Http.send PlantDataResponse


getTimelineReadingIfNewFocus : Model -> Int -> Cmd Msg
getTimelineReadingIfNewFocus model plantId =
    case model.focusedPlantId of
        Just id ->
            case id == plantId of
                True ->
                    Cmd.none

                False ->
                    getTimelineReading plantId

        Nothing ->
            getTimelineReading plantId


getTimelineReading : Int -> Cmd Msg
getTimelineReading plantId =
    let
        url =
            "https://api.plants.sofiapoh.com/plants/"
                ++ toString plantId
                ++ "/hourly-readings?limit=24"
    in
    Http.get url seriesDecoder
        |> Http.send PlantSeriesResponse


mainDecoder : Decoder (List Plant)
mainDecoder =
    Decode.field "plants" (Decode.list plantDecoder)


seriesDecoder : Decoder (List Reading)
seriesDecoder =
    Decode.list readingDecoder


readingDecoder : Decoder Reading
readingDecoder =
    Pipeline.decode Reading
        |> Pipeline.required "plant_id" Decode.int
        |> Pipeline.required "ratio" Decode.float
        |> Pipeline.required "time" Decode.string


plantDecoder : Decoder Plant
plantDecoder =
    Pipeline.decode Plant
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "latestReadingRatio" Decode.float
        |> Pipeline.required "latestReadingAt" Decode.string
        |> Pipeline.optional "genus" Decode.string "mixed"
