module Debug.Diff exposing (diff)

import Native.Diff


type Diff
    = Added String
    | Removed String
    | Same String


type DiffingType
    = StringDiff String String


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


diffToString : Diff -> String
diffToString diff =
    case diff of
        Added x ->
            green x

        Removed x ->
            red x

        Same x ->
            x


diffListToString : List Diff -> String
diffListToString =
    List.map diffToString
        >> String.join ""


diff : a -> a -> String
diff thing other =
    case Native.Diff.diff thing other of
        StringDiff first second ->
            stringDiff (String.toList first) (String.toList second)
                |> diffListToString
