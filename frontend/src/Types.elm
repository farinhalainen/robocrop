module Types exposing (..)

import Http


type alias Plant =
    { id : Int
    , name : String
    , latestValue : Int
    , latestReadingAt : String
    , threshold : Int
    , genus : String
    }


type alias Reading =
    { plantId : Int
    , value : Int
    , time : String
    }


type alias Model =
    { plants : Maybe (List Plant)
    , errorMessage : Maybe String
    , currentView : View
    , focusedPlantId : Maybe Int
    , focusedPlantReadings : Maybe (List Reading)
    }


type Msg
    = PlantDataResponse (Result Http.Error (List Plant))
    | SetFocusedPlant Int
    | ShowListView
    | PlantSeriesResponse (Result Http.Error (List Reading))


type View
    = LoaderView
    | PlantListView


type Family
    = Monstera
    | Spathiphyllum
    | Howea
    | Arum
    | Mixed
