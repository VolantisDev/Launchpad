class EntityFieldWidgetFactory {
    container := ""

    __New(container) {
        this.container := container
    }

    CreateEntityFieldWidget(entityObj, fieldId, definition, guiObj, formMode := "config") {
        knownTypes := this.container.GetParameter("entity_field_widget_type")

        if (!definition.Has("widget") || !definition["widget"]) {
            definition["widget"] := "text"
        }

        if (knownTypes.Has(definition["widget"])) {
            defaults := knownTypes[definition["widget"]]

            if (Type(defaults == "String")) {
                defaults := Map("widget_class", defaults)
            }

            for key, val in defaults {
                if (!definition.Has(key)) {
                    definition[key] := val
                }
            }
        }

        if (!definition.Has("widget_class")) {
            throw EntityException("Widget class not known for type " . definition["widget"])
        }

        widgetClass := definition["widget_class"]

        if (!HasMethod(%widgetClass%)) {
            throw EntityException("Widget class " . widgetClass . " was not found.")
        }

        return %widgetClass%.Create(this.container, entityObj, fieldId, definition, guiObj, formMode)
    }
}
