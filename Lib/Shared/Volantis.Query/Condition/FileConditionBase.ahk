class FileConditionBase extends ConditionBase {
    EvaluateCondition(file, args*) {
        if (!super.EvaluateCondition(file, args*)) {
            return false
        }

        if (!file || !FileExist(file)) {
            return false
        }

        return true
    }
}
