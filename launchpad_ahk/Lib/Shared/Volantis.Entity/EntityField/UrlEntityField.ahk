class UrlEntityField extends StringEntityField {
    DefinitionDefaults(fieldDefinition) {
        defaults := super.DefinitionDefaults(fieldDefinition)

        defaults["validateUrl"] := true
        defaults["widget"] := "url"
        defaults["absolute"] := true

        return defaults
    }
    
    GetValidators(value) {
        validators := super.GetValidators(value)

        if (this.Definition["validateUrl"]) {
            validators.Push(Map(
                "condition", "IsUrlCondition",
                "args", ["", this.Definition["absolute"]]
            ))
        }

        return validators
    }
}
