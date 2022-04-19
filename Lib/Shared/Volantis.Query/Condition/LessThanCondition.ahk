class LessThanCondition extends ConditionBase {
    amount := ""
    allowEqual := false

    __New(amount, allowEqual := false, childConditions := "", negate := false) {
        this.amount := amount
        this.allowEqual := allowEqual
        super.__New(childConditions, negate)
    }

    EvaluateCondition(val) {
        if (this.allowEqual) {
            return val <= this.amount
        } else {
            return val < this.amount
        }
    }
}
