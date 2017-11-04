module Types exposing (..)

import Http


type alias Plant =
    { id : Int
    , name : String
    , latestValue : Int
    , latestReadingAt : String
    , threshold : Int
    }


type alias Reading =
    { id : Int
    , value : Int
    , time : String
    }


type alias Model =
    { plants : Maybe (List Plant)
    , errorMessage : Maybe String
    , currentView : View
    , focusedPlant : Maybe Plant
    , readings : Maybe (List Reading)
    }


type Msg
    = PlantDataResponse (Result Http.Error (List Plant))
    | SetFocusedPlant Plant
    | ShowListView
    | PlantSeriesResponse (Result Http.Error (List Reading))


type View
    = LoaderView
    | PlantListView
    | PlantDetailView


type Family
    = Monstera
    | Howea
    | Arum
