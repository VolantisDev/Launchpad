class EndsWithCondition extends ConditionBase {
    pattern := ""

    __New(pattern, childConditions := "", negate := false) {
        this.pattern := pattern
        super.__New(childConditions, negate)
    }

    EvaluateCondition(value) {
        return SubStr(value, -StrLen(this.pattern)) == this.pattern
    }
}
