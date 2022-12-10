class FileConditionBase extends ConditionBase {
    EvaluateCondition(file, args*) {
        if (!super.EvaluateCondition(file, args*)) {
            return false
        }

        if (!file || !this.Exists(file)) {
            return false
        }

        return true
    }

    Exists(path) {
        return FileExist(path)
    }
}
