module Types exposing (..)
import Random

import Http

type alias Plant =
  { id : Int 
  , name : String
  , latestValue : Int
  , latestReadingAt: String
  , threshold : Int
  }

type alias Model =
  {  plants : List Plant
   , errorMessage : Maybe String
   , currentView : View
   , focusedPlant: Maybe Plant
  }

type Msg 
  = HandlePlantDataResponse (Result Http.Error (List Plant))
  | ShowPlantView Plant
  | ShowListView

type View
  = LoaderView
  | PlantListView
  | PlantDetailView

type Family
    = Monstera
    | Howea
    | Arum
