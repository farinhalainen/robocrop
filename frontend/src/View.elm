module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Styles exposing (..)
import Svg exposing (circle, svg)
import Svg.Attributes exposing (cx, cy, r, viewBox)
import Types exposing (..)
import ViewUtil exposing (getFormattedTime, getLeaf, getVerboseTime)


renderPlant : Plant -> Maybe (List Reading) -> Html Msg
renderPlant plant readings =
    li [ horizontalWrapperStyles plant.latestValue plant.threshold ]
        [ div [ onClick (SetFocusedPlant plant.id), listItemStyles ]
            [ img [ imgStyles, src (getLeaf plant.genus) ] []
            , div [ textWrapperStyles ]
                [ h2 [ plantTitleStyles ] [ text plant.name ]
                , span [] [ text (getVerboseTime plant.latestReadingAt) ]
                ]
            ]
        , timeSeries readings
        ]


timeSeries : Maybe (List Reading) -> Html Msg
timeSeries series =
    case series of
        Nothing ->
            ul []
                []

        Just series ->
            div [ listWrapperStyles ]
                [ ul [ seriesListStyles ] (List.map timeSeriesElement series)
                ]


timeSeriesElement : Reading -> Html Msg
timeSeriesElement reading =
    let
        baselineThreshold =
            1023
    in
    li [ readingStyles ]
        [ svg [ svgStyle, viewBox "0 0 24 24" ]
            [ circle [ cx "12", cy "12", r "12", circleStyles reading.value baselineThreshold ] []
            ]
        , span [] [ text (getFormattedTime reading.time) ]
        ]


loaderView : Model -> Html Msg
loaderView model =
    case model.errorMessage of
        Just message ->
            div []
                [ text message ]

        Nothing ->
            div [ loaderStyles ]
                [ text "Loading..." ]


wrapRenderPlant : Maybe Int -> Maybe (List Reading) -> Plant -> Html Msg
wrapRenderPlant focusedPlantId focusedPlantReadings plant =
    case focusedPlantId of
        Just focusedPlantId ->
            case plant.id == focusedPlantId of
                True ->
                    renderPlant plant focusedPlantReadings

                False ->
                    renderPlant plant Nothing

        Nothing ->
            renderPlant plant Nothing


listView : Model -> Html Msg
listView model =
    let
        plantRenderFunc =
            wrapRenderPlant model.focusedPlantId model.focusedPlantReadings
    in
    case model.plants of
        Just plants ->
            div []
                [ ul [ listStyles ] (List.map plantRenderFunc plants)
                ]

        Nothing ->
            text "No Plants!"


view : Model -> Html Msg
view model =
    case model.currentView of
        LoaderView ->
            loaderView model

        PlantListView ->
            listView model
