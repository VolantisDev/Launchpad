class FileEntityFieldBase extends StringEntityField {
    DefinitionDefaults(fieldDefinition) {
        defaults := super.DefinitionDefaults(fieldDefinition)
        defaults["mustExist"] := false
        defaults["fileMask"] := "*.*"
        defaults["widget"] := "file"

        return defaults
    }

    GetExistsCondition() {
        return Map(
            "condition", "FileExistsCondition",
            "args", []
        )
    }

    GetValidators(value) {
        validators := super.GetValidators(value)

        if (this.Definition["mustExist"] && value) {
            condition := this.GetExistsCondition()

            if (condition) {
                validators.Push(condition)
            }
        }

        if (this.Definition["fileMask"]) {
            ; @todo add a file extension condition
        }

        return validators
    }
}
