class HasFieldCondition extends QueryConditionBase {
    field := ""
    fieldType := ""

    __New(field, fieldType := "", negate := false) {
        this.field := field
        this.fieldType := fieldType
        super.__New([], negate)
    }

    EvaluateCondition(key, data, args*) {
        hasField := data.Has(this.field)

        if (hasField && this.fieldType) {
            hasField := this.FieldTypeMatches(this.fieldType, data[this.field])
        }

        return hasField
    }

    FieldTypeMatches(fieldType, data) {
        fieldTypeMatches := false

        if (Type(fieldType) == "String") {
            fieldTypeMatches := Type(data) == fieldType

            if (!fieldTypeMatches && HasMethod(%fieldType%)) {
                fieldType := %fieldType%
            }
        }

        if (!fieldTypeMatches && Type(fieldType) == "String") {
            fieldTypeMatches := data.HasBase(fieldType.Prototype)
        }

        return fieldTypeMatches
    }
}
