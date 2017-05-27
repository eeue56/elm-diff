module Main exposing (..)

import Platform
import Debug.Diff exposing (displayDiff, diff)


type alias Pet =
    { name : String
    , breed : String
    }


type alias User =
    { name : String
    , age : Int
    , pet : Pet
    }


originalNoah : User
originalNoah =
    { name = "Noah"
    , age = 12
    , pet = { name = "Frodo", breed = "Guinea Pig" }
    }


newNoah : User
newNoah =
    { name = "Noah"
    , age = 14
    , pet = { name = "Cockrel", breed = "Welsummer" }
    }


type Animal
    = Dog Int
    | Cat String


cat =
    Cat "Meow"


dog =
    Dog 5


otherDog =
    Dog 88


x : String
x =
    displayDiff (diff originalNoah newNoah)


y : String
y =
    displayDiff (diff cat dog)


z : String
z =
    displayDiff (diff dog otherDog)


main =
    Platform.program
        { init = ( (), Cmd.none )
        , update = \x m -> ( m, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }
