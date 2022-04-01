class ConditionBase {
    childConditions := []
    negate := false

    __New(childConditions := "", negate := false) {
        if (childConditions) {
            if (!HasBase(childConditions, Array.Prototype)) {
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

        if (this.childConditions && this.childConditions.Length) {
            matches := false

            for index, condition in this.childConditions {
                matches := this.evaluateChildCondition(condition, args*)

                if (!matches) {
                    break
                }
            }
        }

        return matches
    }

    evaluateChildCondition(condition, args*) {
        return condition.Evaluate(args*)
    }

    EvaluateCondition(args*) {
        return false
    }
}
