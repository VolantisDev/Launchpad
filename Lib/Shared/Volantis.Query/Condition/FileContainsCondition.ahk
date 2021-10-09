class FileContainsCondition extends FileConditionBase {
    pattern := ""
    
    __New(pattern, childConditions := "", negate := false) {
        this.str := ""
        super.__New(childConditions, negate)
    }

    EvaluateCondition(file, args*) {
        matches := false

        if (super.EvaluateCondition(file, args*)) {
            Loop Read file {
                if (RegexMatch(A_LoopReadLine, this.pattern)) {
                    matches := true
                    break
                }
            }
        }

        return matches
    }
}
