class HotkeyEntityField extends StringEntityField {
    DefinitionDefaults(fieldDefinition) {
        defaults := super.DefinitionDefaults(fieldDefinition)
        
        defaults["widget"] := "hotkey"

        return defaults
    }

    GetValidators(value) {
        validators := super.GetValidators(value)

        if (value) {
            validators.Push(Map(
                "condition", "IsHotkeyCondition",
                "args", []
            ))
        }

        return validators
    }
}
