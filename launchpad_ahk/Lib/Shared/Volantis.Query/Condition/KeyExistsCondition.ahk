class KeyExistsCondition extends ConditionBase {
    list := ""

    __New(list, childConditions := "", negate := false) {
        this.list := list
        super.__New(childConditions, negate)
    }

    EvaluateCondition(val) {
        return this.list.Has(val)
    }
}
