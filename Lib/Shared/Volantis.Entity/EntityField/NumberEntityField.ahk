class NumberEntityField extends EntityFieldBase {
    static NO_LIMIT := "NO_LIMIT"

    static NumberTypes := Map(
        "number", "Number",
        "float", "Float",
        "integer", "Integer"
    )

    DefinitionDefaults(fieldDefinition) {
        defaults := super.DefinitionDefaults(fieldDefinition)

        defaults["numberType"] := "number"
        defaults["min"] := NumberEntityField.NO_LIMIT
        defaults["max"] := NumberEntityField.NO_LIMIT
        defaults["widget"] := "number"

        return defaults
    }

    GetValidators(value) {
        validators := super.GetValidators(value)

        fieldType := this.Definition["numberType"]

        if (fieldType) {
            if (NumberEntityField.NumberTypes.Has(fieldType)) {
                validators.Push(Map(
                    "condition", "Is" . NumberEntityField.NumberTypes[fieldType] . "Condition",
                    "args", []
                ))
            } else {
                throw EntityException("Numeric type " . fieldType . " is unknown.")
            }
        }
        
        if (this.Definition["min"] != NumberEntityField.NO_LIMIT) {
            validators.Push(Map(
                "condition", "GreaterThanCondition",
                "args", [this.Definition["min"], true]
            ))
        }

        if (this.Definition["max"] != NumberEntityField.NO_LIMIT) {
            validators.Push(Map(
                "condition", "LessThanCondition",
                "args", [this.Definition["max"], true]
            ))
        }

        return validators
    }
}
