class DirEntityField extends FileEntityFieldBase {
    DefinitionDefaults(fieldDefinition) {
        defaults := super.DefinitionDefaults(fieldDefinition)
        
        defaults["fileMast"] := ""
        defaults["widget"] := "directory"

        return defaults
    }

    GetExistsCondition() {
        return Map(
            "condition", "DirExistsCondition",
            "args", []
        )
    }
}
