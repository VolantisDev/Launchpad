class FileConditionBase extends ConditionBase {
    file := ""
    
    __New(file, childConditions := "") {
        this.file := file
        super.__New(childConditions)
    }

    EvaluateCondition() {
        if (!super.EvaluateCondition()) {
            return false
        }

        if (!this.file || !FileExist(this.file)) {
            return false
        }

        return true
    }
}
