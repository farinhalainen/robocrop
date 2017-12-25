module State exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Types exposing (..)


initModel : Model
initModel =
    { plants = Nothing
    , focusedPlant = Nothing
    , currentView = LoaderView
    , errorMessage = Nothing
    , readings = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.batch [ getLatestReading, getTimelineReading ] )


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

        SetFocusedPlant plant ->
            ( { model
                | focusedPlant = Just plant
              }
            , Cmd.none
            )

        ShowListView ->
            ( { model
                | focusedPlant = Nothing
              }
            , Cmd.none
            )

        PlantSeriesResponse result ->
            case result of
                Ok readings ->
                    ( { model | readings = Just readings }, Cmd.none )

                Err error ->
                    ( { model | errorMessage = Just (toString error) }, Cmd.none )


getLatestReading : Cmd Msg
getLatestReading =
    Http.get "http://localhost:4000/plants" mainDecoder
        |> Http.send PlantDataResponse


getTimelineReading : Cmd Msg
getTimelineReading =
    Http.get "http://localhost:4000/plants/1/readings?limit=10" seriesDecoder
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
        |> Pipeline.required "value" Decode.int
        |> Pipeline.required "time" Decode.string


plantDecoder : Decoder Plant
plantDecoder =
    Pipeline.decode Plant
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "latestValue" Decode.int
        |> Pipeline.required "latestReadingAt" Decode.string
        |> Pipeline.required "threshold" Decode.int
