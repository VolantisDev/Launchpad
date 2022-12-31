class BooleanEntityField extends EntityFieldBase {
    DefinitionDefaults(fieldDefinition) {
        defaults := super.DefinitionDefaults(fieldDefinition)
        defaults["widget"] := "checkbox"
        defaults["default"] := false
        return defaults
    }

    GetValue(index := "") {
        value := super.GetValue(index)

        if (!HasBase(value, Array.Prototype)) {
            value := [value]
        }

        newValues := []

        for singleIndex, singleValue in value {
            isTrue := StrLower(singleValue)

            if (isTrue == "true" || isTrue == "false") {
                isTrue := (isTrue == "true")
            }

            newValues.Push(!!isTrue)
        }

        value := newValues

        if (!value.Length) {
            value.Push("")
        }

        if (index && !value.Has(index)) {
            throw AppException("Index out of range")
        }

        if (index) {
            return value[index]
        } else if (this.multiple) {
            return value
        } else {
            return value[1]
        }
    }

    SetValue(value, index := "") {
        if (index || !this.multiple || !HasBase(value, Array.Prototype)) {
            value := !!value
        } else {
            newValues := []

            for singleIndex, singleValue in value {
                newValues.Push(!!singleValue)
            }

            value := newValues
        }

        super.SetValue(value, index)
    }
}
