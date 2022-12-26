class ClassNameEntityField extends StringEntityField {
    GetValidators(value) {
        validators := super.GetValidators(value)

        if (value) {
            validators.Push(Map(
                "condition", "ClassNameExistsCondition",
                "args", []
            ))
        }

        return validators
    }
}
