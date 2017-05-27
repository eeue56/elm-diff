var _user$project$Native_Diff = (function() {
    var diff = function(first, second){

        if (typeof first === "string") return { ctor: "StringDiff", _0: first, _1: second};
        if (typeof first === "object" && Object.keys(first).indexOf("ctor") == -1) 
            return { ctor: "RecordDiff", _0: first, _1: second};
        if (typeof first === "number") return { ctor: "NumberDiff", _0: first, _1: second};

        return { ctor: "NoDiff" };
    };



    return {
        diff: F2(diff)
    };
})();