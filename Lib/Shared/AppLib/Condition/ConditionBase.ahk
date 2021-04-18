class ConditionBase {
    childConditions := []
    negate := false

    __New(childConditions := "", negate := false) {
        if (childConditions) {
            if (Type(childConditions) == "String") {
                childConditions := [childConditions]
            }

            this.childConditions := childConditions
        }

        this.negate := negate
    }

    AddChild(condition) {
        if (Type(this.childConditions) == "String") {
            this.childConditions := []
        }

        this.childConditions.Push(condition)
    }

    Evaluate() {
        result := true

        if (this.childConditions) {
            for index, condition in this.childConditions {
                if (!condition.Evaluate()) {
                    result := false
                    break
                }
            }
        }

        if (result) {
            result := this.EvaluateCondition()
        }

        return this.negate ? !result : result
    }

    EvaluateCondition() {
        return true
    }
}
