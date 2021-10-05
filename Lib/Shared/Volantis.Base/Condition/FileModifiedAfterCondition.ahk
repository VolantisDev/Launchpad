class FileModifiedAfterCondition extends FileConditionBase {
    timestamp := ""
    
    __New(timestamp, file, childConditions := "") {
        this.timestamp := timestamp
        super.__New(file, childConditions)
    }

    EvaluateCondition() {
        if (!super.EvaluateCondition()) {
            return false
        }

        if (!this.file || !FileExist(this.file)) {
            ; Log file doesn't exist
            return false
        }

        modified := FileGetTime(this.file)
        diff := DateDiff(modified, this.timestamp, "S")

        return (diff >= 0)
    }
}
