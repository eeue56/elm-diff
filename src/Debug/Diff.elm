module Debug.Diff exposing (diff)

import Json.Decode as Json
import Json.Encode
import Native.Diff


type Diff
    = Added String
    | Removed String
    | FieldChanged String Int
    | Same String
    | OpenBracket
    | CloseBracket


type DiffingType
    = StringDiff String String
    | RecordDiff Json.Value Json.Value
    | NumberDiff Float Float
    | NoDiff


green : String -> String
green str =
    String.join "" [ "\x1B[32m", str, "\x1B[39m" ]


red : String -> String
red str =
    String.join "" [ "\x1B[31m", str, "\x1B[39m" ]


stringDiff : List Char -> List Char -> List Diff
stringDiff first second =
    case ( first, second ) of
        ( [], _ ) ->
            second
                |> List.map (List.singleton >> String.fromList >> Added)

        ( _, [] ) ->
            first
                |> List.map (List.singleton >> String.fromList >> Removed)

        ( x :: xs, y :: ys ) ->
            if x == y then
                Same (String.fromList [ x ]) :: stringDiff xs ys
            else
                Removed (String.fromList [ x ]) :: Added (String.fromList [ y ]) :: stringDiff xs ys


numberDiff : Float -> Float -> List Diff
numberDiff first second =
    if first == second then
        [ first |> toString |> Same ]
    else
        [ first |> toString |> Removed, second |> toString |> Added ]


fieldDiff : Int -> ( String, Json.Value ) -> ( String, Json.Value ) -> List Diff
fieldDiff depth ( firstName, firstValue ) ( secondName, secondValue ) =
    let
        firstAsString =
            Json.Encode.object [ ( firstName, firstValue ) ]
                |> Json.Encode.encode 4

        secondAsString =
            Json.Encode.object [ ( firstName, firstValue ) ]
                |> Json.Encode.encode 4
    in
        if firstName == secondName && firstValue == secondValue then
            [ Same firstAsString ]
        else
            FieldChanged firstName depth :: internalDiff (depth + 1) firstValue secondValue


recordDiff : Int -> Json.Value -> Json.Value -> List Diff
recordDiff depth first second =
    let
        firstDecoded =
            Json.decodeValue (Json.keyValuePairs Json.value) first
                |> Result.withDefault []

        secondDecoded =
            Json.decodeValue (Json.keyValuePairs Json.value) second
                |> Result.withDefault []
    in
        List.map2 (fieldDiff depth) firstDecoded secondDecoded
            |> List.concat


diffToString : Diff -> String
diffToString diff =
    case diff of
        OpenBracket ->
            "{ "

        CloseBracket ->
            " }"

        Added x ->
            green x

        Removed x ->
            red x

        Same x ->
            x

        FieldChanged x depth ->
            green x ++ " : \n" ++ (String.repeat (depth + 1) "\t")


diffListToString : List Diff -> String
diffListToString =
    List.map diffToString
        >> String.join ""


internalDiff : Int -> a -> a -> List Diff
internalDiff depth thing other =
    case Native.Diff.diff thing other of
        StringDiff first second ->
            stringDiff (String.toList first) (String.toList second)

        RecordDiff first second ->
            OpenBracket :: recordDiff depth first second ++ [ CloseBracket ]

        NumberDiff first second ->
            numberDiff first second

        NoDiff ->
            []


diff : a -> a -> String
diff first second =
    internalDiff 0 first second
        |> diffListToString


displayDiff : String -> String
displayDiff str =
    Debug.log "" str
