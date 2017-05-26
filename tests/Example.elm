module Example exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, string)
import Debug.Diff exposing (diff)


green : String -> String
green str =
    String.join "" [ "\x1B[32m", str, "\x1B[39m" ]


red : String -> String
red str =
    String.join "" [ "\x1B[31m", str, "\x1B[39m" ]


testStringDiffs : Test
testStringDiffs =
    describe "basic expectations"
        [ test "this should succeed" <|
            \() ->
                diff "blah" "bla"
                    |> Expect.equal "bla\x1B[31mh\x1B[39m"
        ]
