class FileModifiedAfterCondition extends FileConditionBase {
    timestamp := ""
    
    __New(timestamp, childConditions := "", negate := false) {
        this.timestamp := timestamp
        super.__New(childConditions, negate)
    }

    EvaluateCondition(file, args*) {
        matches := false

        if (super.EvaluateCondition(file, args*)) {
            modified := FileGetTime(this.file)
            diff := DateDiff(modified, this.timestamp, "S")
            matches := (diff >= 0)
        }

        return matches
    }
}
