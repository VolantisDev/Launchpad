class FieldableEntity extends EntityBase {
    fieldDefinitionsObj := Map()
    fields := Map()
    widgets := Map()
    fieldGroups := ""
    entityFieldFactory := ""
    entityWidgetFactory := ""
    fieldDefinitionsLoaded := false

    FieldDefinitions {
        get => this.GetFieldDefinitions()
    }

    __New(id, entityTypeId, container, fieldFactory, widgetFactory, eventMgr, storageObj, idSanitizer := "", autoLoad := true, parentEntity := "", parentEntityStorage := false) {
        this.entityFieldFactory := fieldFactory
        this.entityWidgetFactory := widgetFactory
        
        super.__New(id, entityTypeId, container, eventMgr, storageObj, idSanitizer, autoLoad, parentEntity, parentEntityStorage)
    }

    static Create(container, eventMgr, id, entityTypeId, storageObj, idSanitizer, autoLoad := true, parentEntity := "", parentEntityStorage := false) {
        className := this.Prototype.__Class

        return %className%(
            id,
            entityTypeId,
            container,
            container.Get("entity_field_factory." . entityTypeId),
            container.Get("entity_widget_factory." . entityTypeId),
            eventMgr,
            storageObj,
            idSanitizer,
            autoLoad,
            parentEntity,
            parentEntityStorage
        )
    }

    GetDefaultFieldGroups() {
        return Map(
            "general", Map(
                "name", "General",
                "weight", 0
            )
        )
    }

    GetFieldGroups() {
        if (!this.fieldGroups) {
            fieldGroups := this.GetDefaultFieldGroups()

            event := EntityFieldGroupsEvent(EntityEvents.ENTITY_FIELD_GROUPS, this.entityTypeId, this, fieldGroups)
            this.eventMgr.DispatchEvent(event)

            event := EntityFieldGroupsEvent(EntityEvents.ENTITY_FIELD_GROUPS_ALTER, this.entityTypeId, this, event.FieldGroups)
            this.eventMgr.DispatchEvent(event)

            groups := event.FieldGroups

            for groupId, group in groups {
                groups[groupId]["id"] := groupId
            }

            this.fieldGroups := fieldGroups
        }

        return this.fieldGroups
    }

    GetAllValues(raw := false) {
        values := Map()

        for key, definition in this.fieldDefinitions {
            field := this.GetField(key)
            values[key] := raw ? field.GetRawValue() : field.GetValue()
        }

        return values
    }

    BaseFieldDefinitions() {
        return Map(
            "id", Map(
                "editable", false,
                "type", "id",
                "weight", -100
            ),
            "name", Map(
                "weight", -75,
                "default", this.idVal
            )
        )
    }

    SetupEntity() {
        this.LoadFieldDefinitions(false)
    }

    LoadFieldDefinitions(reload := false) {
        if (!reload && this.fieldDefinitionsLoaded) {
            return
        }
        
        fieldDefinitions := this.BaseFieldDefinitions()

        event := EntityFieldDefinitionsEvent(EntityEvents.ENTITY_FIELD_DEFINITIONS, this.entityTypeId, this, fieldDefinitions)
        this.eventMgr.DispatchEvent(event)

        event := EntityFieldDefinitionsEvent(EntityEvents.ENTITY_FIELD_DEFINITIONS_ALTER, this.entityTypeId, this, event.FieldDefinitions)
        this.eventMgr.DispatchEvent(event)

        this.fieldDefinitionsObj := event.FieldDefinitions
        this.fieldDefinitionsLoaded := true
    }

    GetFieldDefinitions() {
        this.LoadFieldDefinitions(false)
        return this.fieldDefinitionsObj
    }

    HasField(key) {
        return this.FieldDefinitions.Has(key)
    }

    GetField(key) {
        field := ""

        if (this.HasField(key)) {
            if (this.fields.Has(key)) {
                field := this.fields[key]
            } else {
                field := this._createField(key)
                this.fields[key] := field
            }
        } else {
            throw EntityException("Field key " . key . " does not exist on this entity.")
        }

        return field
    }

    GetWidget(key, guiObj, formMode := "config") {
        widgetId := guiObj.guiId . "_" . formMode . "_" . key

        if (!this.widgets.Has(widgetId)) {
            field := this.GetField(key)
            this.widgets[widgetId] := this.entityWidgetFactory.CreateEntityFieldWidget(this, key, field.GetDefinition(formMode), guiObj, formMode)
        }
    
        return this.widgets[widgetId]
    }

    GetFields(group := "", mode := "") {
        fields := Map()

        for fieldId, fieldDef in this.fieldDefinitions {
            fields[fieldId] := this.GetField(fieldId)
        }

        if (group) {
            filteredFields := Map()

            for fieldId, field in fields {
                definition := field.GetDefinition(mode)
                
                if (group == definition["group"]) {
                    filteredFIelds[fieldId] := field
                }
            }

            fields := filteredFields
        }

        return fields
    }

    _createField(key) {
        if (!this.fieldDefinitions.Has(key)) {
            throw EntityException("Attempted to create unknown field " . key . " on entity . " . this.Id)
        }

        this.fields[key] := this.entityFieldFactory.CreateEntityField(this, this.GetData(), key, this.fieldDefinitions[key])
        return this.fields[key]
    }

    GetValue(key) {
        return this.GetField(key).GetValue()
    }

    SetValue(key, value) {
        this.GetField(key).SetValue(value)
    }

    Has(key, allowEmpty := true) {
        field := this.GetField(key)
        hasValue := field.HasValue()

        if (hasValue && !allowEmpty) {
            hasValue := !field.IsEmpty()
        }

        return hasValue
    }

    DeleteValue(key) {
        return this.GetField(key).DeleteValue()
    }

    Validate(recursive := true) {
        validateResult := super.Validate()

        for key, definition in this.fieldDefinitions {
            field := this.GetField(key)
            fieldResult := field.Validate()

            if (!fieldResult["success"]) {
                validateResult["success"] := false
                validateResult["invalidKeys"].Push(key)
            }
        }

        return validateResult
    }

    GetReferencedEntities(onlyChildren := false) {
        entities := []

        for key, field in this.GetFields() {
            definition := field.Definition

            if (definition.Has("type") && definition["type"] == "entity_reference" && (!onlyChildren || (definition.Has("child") && definition["child"]))) {
                entityObj := this.GetField(key).GetValue()

                if (entityObj) {
                    entities.Push(entityObj)
                }
            }
        }

        return entities
    }

    RevertToDefault(key) {
        this.GetField(key).DeleteValue()
    }

    RefreshEntityData(recurse := true, reloadUserData := false) {
        super.RefreshEntityData(recurse, reloadUserData)

        for widgetId, widget in this.widgets {
            if (widget.IsRendered) {
                widget.ResetValueFromEntity()
            }
        }
    }

    InitializeDefaults() {
        defaults := super.InitializeDefaults()

        for key, fieldObj in this.GetFields() {
            defaults[fieldObj.Definition["storageKey"]] := fieldObj.Definition["default"]
        }

        return defaults
    }
}
