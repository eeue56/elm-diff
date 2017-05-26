var _user$project$Native_Diff = (function() {
    var diff = function(first, second){

        if (typeof first === "string") return { ctor: "StringDiff", _0: first, _1: second};

        return "";
    };



    return {
        diff: F2(diff)
    };
})();