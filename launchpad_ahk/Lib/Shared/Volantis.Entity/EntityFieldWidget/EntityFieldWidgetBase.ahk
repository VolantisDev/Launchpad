class EntityFieldWidgetBase {
    container := ""
    entityObj := ""
    fieldId := ""
    definitionObj := ""
    controlObj := ""
    rendered := false
    guiObj := ""
    formMode := ""
    merger := ""
    eventMgr := ""

    IsRendered {
        get => this.rendered
    }

    Definition {
        get => this.definitionObj
        set => this.definitionObj := value
    }

    __New(container, entityObj, fieldId, definition, guiObj, formMode, merger) {
        this.container := container
        this.eventMgr := container.Get("manager.event")
        this.entityObj := entityObj
        this.fieldId := fieldId
        this.guiObj := guiObj
        this.formMode := formMode
        this.merger := merger

        this.InitializeDefinition(definition)
    }

    InitializeDefinition(definition) {
        defaults := this.GetDefaultDefinition(definition)
        params := this.merger.Merge(defaults, definition)
        this.definitionObj := GuiControlParameters(params)
    }

    static Create(container, entityObj, fieldId, definition, guiObj, formMode := "config") {
        className := this.Prototype.__Class

        return %className%(
            container,
            entityObj,
            fieldId,
            definition,
            guiObj,
            formMode,
            container.Get("merger.list")
        )
    }

    GetDefaultDefinition(definition) {
        return Map(
            "showDefaultCheckbox", true,
            "controlClass", "",
            "controlParams", [],
            "tooltip", ""
        )
    }

    IsModified() {
        ; @todo Return true if modified so that the value can be preserved on refresh
        return false
    }

    GetEntityField() {
        return this.entityObj.GetField(this.fieldId)
    }

    ResetValueFromEntity() {
        this.SetWidgetValue(this.GetEntityField().GetRawValue())
    }

    WriteValueToEntity() {
        this.GetEntityField().SetValue(this.GetWidgetValue(true))
    }

    /**
     * Always override the following three methods in child classes
     */

    RenderWidget(guiControlParams) {
        if (this.Definition["controlClass"]) {
            this.controlObj := this.AddEntityCtl(guiControlParams)
            this.rendered := true
        } else {
            throw EntityException("No control class set, cannot render entity field")
        }
    }

    AddEntityCtl(guiControlParams) {
        field := this.GetEntityField()

        params := [
            this.Definition["title"],
            this.entityObj,
            this,
            this.fieldId,
            this.Definition["showDefaultCheckbox"],
            this.Definition["controlClass"]
        ]

        ; @todo Standardize rendering help text and description and tooltip

        for index, param in this.Definition["controlParams"] {
            params.Push(param)
        }

        ctl := this.guiObj.Add("EntityControl", guiControlParams.GetOptions(), params*)
        this.AddTooltip(ctl)

        return ctl
    }

    AddTooltip(controlObj) {
        if (this.Definition["tooltip"]) {
            controlObj.ctl.ToolTip := this.Definition["tooltip"]
        }
    }

    GetWidgetValue(submitGui := false) {
        val := ""

        if (this.controlObj) {
            val := this.controlObj.GetValue(submitGui)
        }

        return val
    }

    SetWidgetValue(value) {
        if (this.controlObj) {
            this.controlObj.SetValue(value)
        }
    }
}
