class BooleanEntityField extends EntityFieldBase {
    DefinitionDefaults(fieldDefinition) {
        defaults := super.DefinitionDefaults(fieldDefinition)
        defaults["widget"] := "checkbox"
        return defaults
    }

    GetValue() {
        isTrue := StrLower(super.GetValue())

        if (isTrue == "true" || isTrue == "false") {
            isTrue := (isTrue == "true")
        }

        return !!(isTrue)
    }

    SetValue(value) {
        super.SetValue(!!(value))
    }
}
