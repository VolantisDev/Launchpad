class ContainsCondition extends ConditionBase {
    pattern := ""

    __New(pattern, childConditions := "", negate := false) {
        this.pattern := pattern
        super.__New(childConditions, negate)
    }

    EvaluateCondition(val) {
        matches := false

        if (Type(val) == "String") {
            matches := !!InStr(val, this.pattern)
        } else if (Type(val) == "Map") {
            matches := val.Has(this.pattern)
        } else if (Type(val) == "Array") {
            for index, item in val {
                if (item == this.pattern) {
                    matches := true
                    break
                }
            }
        } else {
            throw QueryException("Contains condition is against unsupported type: " . Type(val))
        }

        return matches
    }
}
