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

    Evaluate(args*) {
        matches := this.evaluateChildConditions(args*)

        if (matches) {
            matches := this.EvaluateCondition(args*)
        }

        return this.negate ? !matches : matches
    }

    evaluateChildConditions(args*) {
        matches := true

        if (this.childConditions) {
            matches := false

            for index, condition in this.childConditions {
                matches := condition.Evaluate()

                if (!matches) {
                    break
                }
            }
        }

        return matches
    }

    EvaluateCondition(args*) {
        return false
    }
}
