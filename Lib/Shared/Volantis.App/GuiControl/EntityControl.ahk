class EntityControl extends GuiControlBase {
    innerControl := ""
    defaultCtl := ""
    entityObj := ""
    fieldName := ""
    emptyValue := ""
    dependentFields := []
    refreshDataOnChange := false
    widget := ""
    entityField := ""

    CreateControl(entity, widget, fieldName, showDefaultCheckbox, controlClass, params*) {
        super.CreateControl()

        if (entity == "") {
            entity := this.guiObj.entityObj
        }

        this.fieldName := fieldName
        this.widget := widget
        this.entityObj := entity
        this.entityField := entity.GetField(fieldName)
        checkW := 0
        isDisabled := false

        if (showDefaultCheckbox) {
            ctl := this.DefaultCheckbox(entity, fieldName)
            this.defaultCtl := ctl
            ctl.GetPos(,, &checkW)
            isDisabled := !this.entityField.HasOverride()
        }

        parameters := this.parameters
        controlW := parameters["contentWidth"]
        text := (this.entityField.HasValue() || this.entityField.Definition["default"]) 
            ? this.entityField.GetRawValue() 
            : this.emptyValue

        if (checkW) {
            controlW -= (checkW + this.guiObj.margin)
        }

        if (checkW) {
            parameters := parameters.Clone()
                .SetOption("x", "+" . this.guiObj.margin)
                .SetOption("y", "p")
                .SetOption("w", controlW)
        }

        opts := parameters.GetOptionsString(parameters["options"], [
            "w" . controlW, 
            "x" . this.guiObj.margin, 
            "y+" . this.guiObj.margin, 
            "v" . fieldName
        ])

        this.innerControl := this.guiObj.Add(controlClass, opts, "", text, params*)

        this.ctl := this.innerControl.ctl
        this.innerControl.RegisterHandler("Change", this.RegisterCallback("OnInnerControlChange"))
        this.ToggleEnabled(!isDisabled)
        return this.innerControl
    }

    OnInnerControlChange(ctl, info) {
        this.widget.WriteValueToEntity()

        if (this.refreshDataOnChange && (!this.dependentFields || this.dependentFields.Length == 0)) {
            this.entityObj.UpdateDataSourceDefaults()
        }

        this.SetDependentFieldValues()
    }

    AddDependentField(field) {
        this.dependentFields.Push(field)
        return this.dependentFields
    }

    DefaultCheckbox(entity, fieldName) {
        checkedText := !this.entityField.HasOverride() ? " Checked" : ""
        parameters := this.parameters.Clone()
        parameters["position"]["w"] := ""
        parameters.RemoveOption("w")
        optsStr := parameters.GetOptionsString(parameters["options"], "vDefault" . fieldName . " xs h25 y+" . this.guiObj.margin . checkedText, false, false)
        ctl := this.guiObj.guiObj.AddCheckBox(optsStr, "Default")
        ctl.ToolTip := "When checked, the default value determined by various other factors in " . this.app.appName . " will be used (and shown to the right if available). When unchecked, the value you set here will be used instead."
        ctl.OnEvent("Click", this.RegisterCallback("OnDefaultCheckbox"))

        return ctl
    }

    OnDefaultCheckbox(chk, info) {
        this.guiObj.Submit(false)
        useDefault := !!(chk.Value)

        if (useDefault) {
            this.entityField.DeleteValue()
            newVal := this.emptyValue

            if (this.entityField.HasValue() || this.entityField.Definition["default"]) {
                rawVal := this.entityField.GetRawValue()

                if (rawVal) {
                    newVal := rawVal
                }
            }

            this.SetText(newVal)
        } else {
            this.entityField.SetValue(this.entityField.GetRawValue())
        }

        this.SetDependentFieldValues()
        this.ToggleEnabled(!useDefault)
    }

    SetDependentFieldValues() {
        if (this.dependentFields && this.dependentFields.Length > 0) {
            this.entityObj.UpdateDataSourceDefaults()

            for index, field in this.dependentFields {
                this.guiObj.guiObj[field].Value := this.entityObj.GetField(field).GetRawValue()
            }
        }
    }

    SetText(text) {
        this.innerControl.SetText(text)
    }

    ToggleEnabled(isEnabled) {
        this.innerControl.ToggleEnabled(isEnabled)
    }
}
