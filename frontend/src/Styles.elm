module Styles exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import ViewUtil exposing (getBackgroundColor)


loaderStyles =
    style
        [ ( "margin", "10px" ) ]


plantTitleStyles =
    style
        [ ( "margin", "10px 0" )
        ]


imgStyles =
    style
        [ ( "width", "120px" )
        , ( "height", "110px" )
        ]


horizontalWrapperStyles drynessVal threshold =
    style
        [ ( "backgroundColor", interpolation drynessVal threshold )
        , ( "overflow", "hidden" )
        , ( "padding", "5px" )
        ]


listItemStyles =
    style
        [ ( "padding", "10px" )
        , ( "display", "flex" )
        , ( "alignItems", "flex-start" )
        ]


textWrapperStyles : Attribute msg
textWrapperStyles =
    style
        [ ( "display", "flex" )
        , ( "flexDirection", "column" )
        , ( "marginLeft", "20px" )
        , ( "marginTop", "10px" )
        ]


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
        , ( "margin", "5px" )
        , ( "padding", "0" )
        , ( "display", "flex" )
        , ( "background", "white" )
        , ( "justifyContent", "flex-start" )
        , ( "overflowX", "auto" )
        ]


listWrapperStyles =
    style
        [ ( "display", "flex" )
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
