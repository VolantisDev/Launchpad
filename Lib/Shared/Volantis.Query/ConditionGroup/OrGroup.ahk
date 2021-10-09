class OrGroup extends ConditionGroupBase {
    evaluateChildConditions(args*) {
        matches := true

        if (this.childConditions) {
            matches := false

            for index, condition in this.childConditions {
                matches := condition.Evaluate()

                if (matches) {
                    break
                }
            }
        }

        return matches
    }

    EvaluateCondition(args*) {
        return true
    }
}
