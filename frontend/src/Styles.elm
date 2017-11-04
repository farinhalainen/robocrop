module Styles exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import ViewUtil exposing (getBackgroundColor)

listStyles : Attribute msg
listStyles =
    style
        [ ("listStyle", "none")
        , ("padding", "0")
        , ("margin", "0")
        ]

expandedStyles : a -> Bool -> Attribute msg
expandedStyles plant isFocused =
    let
        plantHeight =
            if isFocused then
                "600px"
            else
                "auto"
    in
        style
            [ ("height", plantHeight)
            , ("transition", "height 0.4s")
            ]

listItemStyles : Int -> Int -> Html.Attribute msg
listItemStyles drynessVal threshold =
    let
        --dry = toFloat (Basics.max 0 (drynessVal - 512))
        --t = toFloat(Basics.max drynessVal threshold) - 512.0
        dry = toFloat drynessVal
        t = toFloat(Basics.max drynessVal threshold)
    in
        style 
            [ ("backgroundColor", getBackgroundColor (dry / t))
            , ("padding", "10px")
            , ("display", "flex")
            ]

textWrapperStyles : Attribute msg
textWrapperStyles =
    style
        [ ("display", "flex")
        , ("flexDirection", "column")
        , ("marginLeft", "10px")
        ]