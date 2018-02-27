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
            paddedInt (minute day)
    in
    hours ++ ":" ++ mins


paddedInt : Int -> String
paddedInt int =
    if int < 10 then
        "0" ++ (int |> toString)
    else
        int |> toString


getVerboseTime : String -> String
getVerboseTime date =
    let
        day =
            renderTime date |> getDay |> toString

        time =
            renderTime date |> getHourAndMin
    in
    "Last reading on " ++ day ++ " at " ++ time


getFormattedTime : String -> String
getFormattedTime date =
    renderTime date |> getHourAndMin


getLeaf : String -> String
getLeaf genus =
    case genus of
        "Monstera" ->
            "./icons/leaf_1.svg"

        "Spathiphyllum" ->
            "./icons/leaf_3.svg"

        "Howea" ->
            "./icons/leaf_2.svg"

        _ ->
            "./icons/leaf_4.svg"
