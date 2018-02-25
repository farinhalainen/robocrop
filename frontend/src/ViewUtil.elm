module ViewUtil exposing (..)

import Color exposing (Color)
import Color.Convert exposing (colorToHex, hexToColor)
import Color.Interpolate exposing (..)
import Date exposing (..)


startGreen : Color
startGreen =
    Color.rgb 37 179 113


endYellow : Color
endYellow =
    Color.rgb 255 201 102


getBackgroundColor : Float -> String
getBackgroundColor value =
    interpolate RGB startGreen endYellow value
        |> colorToHex


getRandomLeaf : { a | leafNumber : String } -> String
getRandomLeaf model =
    "./icons/leaf_" ++ model.leafNumber ++ ".svg"


renderTime : String -> Date
renderTime time =
    fromString time |> Result.withDefault (Date.fromTime 0)


getDay : Date -> Day
getDay day =
    dayOfWeek day


getHourAndMin : Date -> String
getHourAndMin day =
    let
        hours =
            hour day |> toString

        mins =
            minute day |> toString

        period =
            if hour day > 12 then
                "pm"
            else
                "am"
    in
    hours ++ ":" ++ mins ++ " " ++ period


getFormattedTime : String -> String
getFormattedTime date =
    let
        day =
            renderTime date |> getDay |> toString

        time =
            renderTime date |> getHourAndMin
    in
    "Last reading on " ++ day ++ " at " ++ time
