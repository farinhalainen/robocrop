module Styles exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import ViewUtil exposing (getBackgroundColor)


listStyles : Attribute msg
listStyles =
    style
        [ ( "listStyle", "none" )
        , ( "padding", "0" )
        , ( "margin", "0" )
        ]


seriesListStyles : Attribute msg
seriesListStyles =
    style
        [ ( "listStyle", "none" )
        , ( "padding", "10px" )
        , ( "margin", "5px" )
        , ( "display", "flex" )
        , ( "background", "white" )
        , ( "justifyContent", "center" )
        ]


readingStyles : Attribute msg
readingStyles =
    style
        [ ( "margin", "10px" )
        , ( "display", "flex" )
        , ( "flexDirection", "column" )
        , ( "alignItems", "center" )
        , ( "width", "80px" )
        ]


svgStyle =
    style
        [ ( "width", "24px" )
        , ( "height", "24px" )
        ]


circleStyles value threshold =
    style
        [ ( "fill", interpolation value threshold )
        ]


interpolation drynessVal threshold =
    let
        dry =
            toFloat drynessVal

        t =
            toFloat (Basics.max drynessVal threshold)
    in
    getBackgroundColor (dry / t)


listItemStyles : Int -> Int -> Html.Attribute msg
listItemStyles drynessVal threshold =
    style
        [ ( "backgroundColor", interpolation drynessVal threshold )
        , ( "padding", "10px" )
        , ( "display", "flex" )
        , ( "alignItems", "flex-start" )
        ]


textWrapperStyles : Attribute msg
textWrapperStyles =
    style
        [ ( "display", "flex" )
        , ( "flexDirection", "column" )
        , ( "marginLeft", "10px" )
        ]
