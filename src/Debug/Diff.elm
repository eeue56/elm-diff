module Debug.Diff exposing (diff)

import Native.Diff


diff : a -> a -> String
diff thing other =
    Native.Diff.diff thing other
