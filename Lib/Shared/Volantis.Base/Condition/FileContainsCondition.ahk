class FileContainsCondition extends FileConditionBase {
    str := ""
    
    __New(str, file, childConditions := "") {
        this.str := ""
        super.__New(file, childConditions)
    }

    EvaluateCondition() {
        if (!super.EvaluateCondition()) {
            return false
        }

        Loop Read this.file {
            if (RegexMatch(A_LoopReadLine, this.str)) {
                return true
            }
        }

        return false
    }
}
