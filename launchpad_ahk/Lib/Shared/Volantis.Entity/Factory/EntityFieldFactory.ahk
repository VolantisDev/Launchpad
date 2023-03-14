class EntityFieldFactory {
    container := ""
    entityTypeId := ""

    __New(container, entityTypeId) {
        this.container := container
        this.entityTypeId := entityTypeId
    }

    CreateEntityField(entityObj, dataObj, fieldId, definition) {
        knownTypes := this.container.GetParameter("entity_field_type")

        if (!definition.Has("type") || !definition["type"]) {
            definition["type"] := "string"
        }

        if (knownTypes.Has(definition["type"])) {
            defaults := knownTypes[definition["type"]]

            if (Type(defaults == "String")) {
                defaults := Map("field_class", defaults)
            }

            for key, val in defaults {
                if (!definition.Has(key)) {
                    definition[key] := val
                }
            }
        }

        if (!definition.Has("field_class")) {
            throw EntityException("Field class not known for type " . definition["type"])
        }

        fieldClass := definition["field_class"]

        if (!HasMethod(%fieldClass%)) {
            throw EntityException("Field class " . fieldClass . " was not found.")
        }

        return %fieldClass%.Create(this.container, this.entityTypeId, entityObj, dataObj, fieldId, definition)
    }
}
