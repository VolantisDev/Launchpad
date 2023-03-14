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
        } else if (HasBase(val, Map.Prototype)) {
            matches := val.Has(this.pattern)
        } else if (HasBase(val, Array.Prototype)) {
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
