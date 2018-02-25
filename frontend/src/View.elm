module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Styles exposing (..)
import Types exposing (..)
import ViewUtil exposing (getFormattedTime)


renderPlant : Plant -> Bool -> Html Msg
renderPlant plant isFocused =
    li [ expandedStyles plant isFocused ]
        [ div [ onClick (SetFocusedPlant plant), listItemStyles plant.latestValue plant.threshold ]
            [ img [ src "./icons/leaf_3.svg" ] []
            , div [ textWrapperStyles ]
                [ h3 [] [ text plant.name ]
                , p [] [ text (getFormattedTime plant.latestReadingAt) ]
                , span [] [ text (toString plant.latestValue) ]
                ]
            ]
        ]


loaderView : Model -> Html Msg
loaderView model =
    case model.errorMessage of
        Just message ->
            div [ class "error" ]
                [ text message ]

        Nothing ->
            text "Loading..."


wrapRenderPlant : Maybe Plant -> Plant -> Html Msg
wrapRenderPlant focused_plant plant =
    case focused_plant of
        Just focused_plant ->
            renderPlant plant (plant == focused_plant)

        Nothing ->
            renderPlant plant False


listView : Model -> Html Msg
listView model =
    let
        partialWrapRenderPlant =
            wrapRenderPlant model.focusedPlant
    in
    case model.plants of
        Just plants ->
            div []
                [ ul [ listStyles ] (List.map partialWrapRenderPlant plants)
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

        PlantDetailView ->
            listView model
