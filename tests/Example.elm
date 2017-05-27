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


testRecordDiffs : Test
testRecordDiffs =
    describe "record diffs"
        [ test "an updated field should be green then red" <|
            \() ->
                diff { name = "blah" } { name = "bla" }
                    |> Expect.equal ("{ " ++ green "name" ++ " : \n\t" ++ "bla\x1B[31mh\x1B[39m" ++ " }")
        , test "a nested field should be green then red" <|
            \() ->
                diff { person = { name = "blah" } } { person = { name = "bla" } }
                    |> Expect.equal ("{ " ++ green "person" ++ " : \n\t" ++ "{ " ++ green "name" ++ " : \n\t\t" ++ "bla\x1B[31mh\x1B[39m" ++ " }" ++ " }")
        ]


testNumberDiffs : Test
testNumberDiffs =
    describe "number diffs"
        [ test "an updated field should be green then red" <|
            \() ->
                diff 5 7
                    |> Expect.equal (red "5" ++ green "7")
        ]
