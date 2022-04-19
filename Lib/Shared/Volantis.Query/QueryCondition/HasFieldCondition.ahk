class HasFieldCondition extends QueryConditionBase {
    field := ""
    fieldType := ""

    __New(field, fieldTypeId := "", negate := false) {
        this.field := field
        this.fieldTypeId := fieldTypeId
        super.__New([], negate)
    }

    EvaluateCondition(key, data, args*) {
        hasField := data.Has(this.field)

        if (hasField && this.fieldType) {
            hasField := this.FieldTypeMatches(this.fieldType, data[this.field])
        }

        return hasField
    }

    FieldTypeMatches(fieldTypeId, data) {
        fieldTypeMatches := false

        if (Type(fieldTypeId) == "String") {
            fieldTypeMatches := Type(data) == fieldTypeId

            
            if (!fieldTypeMatches && HasMethod(%fieldTypeId%)) {
                fieldTypeId := %fieldTypeId%
            }
        }

        if (!fieldTypeMatches && Type(fieldTypeId) == "String") {
            fieldTypeMatches := data.HasBase(%fieldTypeId%.Prototype)
        }

        return fieldTypeMatches
    }
}
