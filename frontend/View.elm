module View exposing (..)

import Styles exposing (..)
import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import ViewUtil exposing (getRandomLeaf)

renderPlant : Plant -> Html Msg
renderPlant plant =

    li [onClick (ShowPlantView plant), listItemStyles plant.latestValue plant.threshold ]
    [ img [src "./icons/leaf_2.svg"] []
    , div [textWrapperStyles]
        [ h3 [] [text plant.name]
        , p []  [text plant.latestReadingAt]
        , span [] [text (toString plant.latestValue)]
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

listView : Model -> Html Msg
listView model =
    div [] 
       [ ul [listStyles] (List.map renderPlant model.plants)
       ]

detailView : Model -> Html Msg
detailView model =
    case model.focusedPlant of
        Just plant ->
            div [] 
                [ h4 [] [text plant.name]
                , button [onClick ShowListView] [text "Go Back"]
                ]   
        Nothing ->
            text "Error"

view : Model -> Html Msg
view model =
    case model.currentView of
        LoaderView ->
            loaderView model
        PlantListView ->
            listView model
        PlantDetailView ->
            detailView model