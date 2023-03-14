class IdEntityField extends EntityFieldBase {
    DefinitionDefaults(fieldDefinition) {
        defaults := super.DefinitionDefaults(fieldDefinition)

        defaults["required"] := true
        defaults["unique"] := true
        defaults["editable"] := false
        defaults["callbacks"]["GetValue"] := ObjBindMethod(this, "_getId")
        defaults["callbacks"]["SetValue"] := ObjBindMethod(this, "_setId")
        defaults["callbacks"]["HasValue"] := ObjBindMethod(this, "_hasId")
        defaults["callbacks"]["HasOverride"] := ObjBindMethod(this, "_hasId")
        defaults["callbacks"]["IsEmpty"] := ObjBindMethod(this, "_hasId", true)
        defaults["callbacks"]["DeleteValue"] := ObjBindMethod(this, "_setId", "")
        
        return defaults
    }

    _hasId(negate := false) {
        return this.entityObj.HasId(negate)
    }

    _getId() {
        return this.entityObj.GetId()
    }

    _setId(value) {
        this.entityObj.SetId(value)
    }
}
