class StartsWithCondition extends ConditionBase {
    pattern := ""

    __New(pattern, childConditions := "", negate := false) {
        this.pattern := pattern
        super.__New(childConditions, negate)
    }

    EvaluateCondition(val) {
        return SubStr(val, 1, StrLen(this.pattern)) == this.pattern
    }
}
