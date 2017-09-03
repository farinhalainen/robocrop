module ViewUtil exposing (..)

import Color exposing (Color)
import Color.Interpolate exposing (..)
import Color.Convert exposing (colorToHex, hexToColor)
import Random


startGreen : Color
startGreen =
    Color.rgb 37 179 113

endYellow : Color
endYellow =
    Color.rgb 255 201 102

getBackgroundColor value =
    interpolate RGB startGreen endYellow value
    |> colorToHex


getRandomLeaf model =

    "./icons/leaf_" ++ model.leafNumber ++ ".svg"
