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
        [ test "a removed character should be red" <|
            \() ->
                diff "blah" "bla"
                    |> Expect.equal "bla\x1B[31mh\x1B[39m"
        , test "an added character should be green" <|
            \() ->
                diff "bla" "blah"
                    |> Expect.equal "bla\x1B[32mh\x1B[39m"
        , test "a removed and added character should be red then green" <|
            \() ->
                diff "blah" "blag"
                    |> Expect.equal "bla\x1B[31mh\x1B[39m\x1B[32mg\x1B[39m"
        ]
