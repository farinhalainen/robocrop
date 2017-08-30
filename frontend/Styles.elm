module Styles exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import ViewUtil exposing (getBackgroundColor)

listStyles =
    style
        [ ("listStyle", "none")
        , ("padding", "0")
        , ("margin", "0")
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
            [ ("backgroundColor", getBackgroundColor (Debug.log "d" dry / Debug.log "t" t))
            , ("padding", "10px")
            , ("display", "flex")
            ]


textWrapperStyles =
    style
        [ ("display", "flex")
        , ("flexDirection", "column")
        , ("marginLeft", "10px")
        ]