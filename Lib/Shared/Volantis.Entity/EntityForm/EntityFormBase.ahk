class EntityFormBase {
    entityObj := ""
    errors := Map()
    fields := ""
    fieldWidgets := Map()
    guiObj := ""
    formMode := ""

    Entity {
        get => this.entityObj
        set => this.entityObj := value
    }

    static FORM_MODE_EDIT := "edit"
    static FORM_MODE_VALIDATE := "validate"
    static FORM_MODE_EMBED := "embed"

    __New(entityObj, guiObj, formMode) {
        this.entityObj := entityObj
        this.guiObj := guiObj
        this.formMode := formMode
    }

    _sortItems(items) {
        sortedMap := Map()

        for id, item in items {
            weight := 0

            if (HasBase(item, Map.Prototype)) {
                weight := item["weight"]
            } else if (HasBase(item, EntityFieldWidgetBase.Prototype) || HasBase(item, EntityFieldBase.Prototype)) {
                weight := item.Definition["weight"]
            }
            
            if (!sortedMap.Has(weight)) {
                sortedMap[weight] := []
            }
            
            sortedMap[weight].Push(item)
        }

        sortedArray := []

        for weight, weightItems in sortedMap {
            sortedArray.Push(weightItems*)
        }

        return sortedArray
    }

    GetFieldWidgets(groupId := "") {
        widgets := Map()

        for fieldKey, field in this.Entity.GetFields(groupId, this.formMode) {
            definition := field.GetDefinition(this.formMode)
            
            if (definition["formField"] && (definition["editable"] || !field.HasValue())) {
                widgets[fieldKey] := this.GetFieldWidget(fieldKey, field)
            }
        }

        return this._sortItems(widgets)
    }

    GetFieldWidget(fieldKey, field) {
        if (!this.fieldWidgets.Has(fieldKey)) {
            if (field.GetDefinition(this.formMode).Has("widget")) {
                this.fieldWidgets[fieldKey] := this.entityObj.GetWidget(fieldKey, this.guiObj, this.formMode)
            } else {
                throw EntityException("Field does not have valid widget type.")
            }
        }

        return this.fieldWidgets[fieldKey]
    }

    GetFieldGroups(includeEmpty := false) {
        groups := this.Entity.GetFieldGroups()
        
        if (!includeEmpty) {
            filteredGroups := Map()

            for fieldKey, field in this.Entity.GetFields() {
                definition := field.GetDefinition(this.formMode)
                groupId := definition["group"]

                if (definition["formField"] && groupId && groups.Has(groupId) && !filteredGroups.Has(groupId)) {
                    filteredGroups[groupId] := groups[groupId]
                }
            }

            groups := filteredGroups
        }

        return this._sortItems(groups)
    }

    RenderEntityForm(guiControlParams) {
        entityTypeObj := this.Entity.EntityType
        groups := this.GetFieldGroups()

        if (groups.Length > 1) {
            this.RenderFieldGroups(groups, guiControlParams)
        } else {
            widgets := this.GetFieldWidgets()

            if (widgets.Length) {
                this.RenderFields(widgets, guiControlParams)
            }
        }
    }

    GetTabNames(fieldGroups) {
        tabNames := []

        for key, definition in fieldGroups {
            tabNames.Push(definition["name"])
        }

        return tabNames
    }

    RenderFieldGroups(fieldGroups, guiControlParams) {
        ; @todo Abstract this to a TabsFieldGroup class
        tabNames := this.GetTabNames(fieldGroups)

        guiObj := this.guiObj

        if (HasBase(guiObj, GuiBase.Prototype)) {
            guiObj := guiObj.guiObj
        }

        tabs := guiObj.Add("Tab3", guiControlParams.GetOptionsString() . " +0x100", tabNames)

        for index, definition in fieldGroups {
            tabs.UseTab(definition["name"])
            this.RenderFieldGroup(definition["id"], definition, guiControlParams)
        }

        tabs.UseTab()
    }

    RenderFieldGroup(groupId, groupDefinition, guiControlParams) {
        widgets := this.GetFieldWidgets(groupId)

        if (widgets.Length) {
            this.RenderFields(widgets, guiControlParams.SubRegion())
        }
    }

    RenderFields(widgets, guiControlParams) {
        for index, widget in widgets {
            widget.RenderWidget(guiControlParams.SubRegion())
        }
    }

    GetButtonDefinitions() {
        return this.Entity.GetEditorButtons(this.formMode)
    }

    GetFormDescription() {
        return this.Entity.GetEditorDescription(this.formMode)
    }

    SubmitForm(hide := true) {
        this.guiObj.Submit(hide)

        for widget in this.fieldWidgets {
            widget.WriteValueToEntity()
        }
    }
}
