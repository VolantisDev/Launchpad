class EntityControl extends GuiControlBase {
    innerControl := ""
    defaultCtl := ""
    entityObj := ""
    fieldName := ""
    emptyValue := ""
    dependentFields := []
    refreshDataOnChange := false

    CreateControl(entity, fieldName, showDefaultCheckbox, controlClass, params*) {
        super.CreateControl()

        if (entity == "") {
            entity := this.guiObj.entityObj
        }

        this.fieldName := fieldName
        this.entityObj := entity
        checkW := 0
        isDisabled := false

        if (showDefaultCheckbox) {
            ctl := this.DefaultCheckbox(entity, fieldName)
            this.defaultCtl := ctl
            ctl.GetPos(,,checkW)
            isDisabled := !entity.UnmergedConfig.Has(fieldName)
        }
        
        controlW := this.guiObj.windowSettings["contentWidth"]

        if (checkW) {
            controlW -= (checkW + this.guiObj.margin)
        }

        defaultX := checkW ? "x+" . this.guiObj.margin : "x" . this.guiObj.margin
        defaultY := checkW ? "yp" : "y+" . this.guiObj.margin
        defaults := ["w" . controlW, defaultX, defaultY, "v" . fieldName]
        opts := this.SetDefaultOptions(this.options, defaults)
        text := (this.entityObj.Config.Has(this.fieldName) && this.entityObj.Config[this.fieldName] != "") ? this.entityObj.Config[this.fieldName] : this.emptyValue
        this.innerControl := this.guiObj.Add(controlClass, this.GetOptionsString(opts), "", text, params*)
        this.ctl := this.innerControl.ctl
        this.innerControl.RegisterHandler("Change", this.RegisterCallback("OnInnerControlChange"))
        this.ToggleEnabled(!isDisabled)
        return this.innerControl
    }

    OnInnerControlChange(ctl, info) {
        val := Trim(this.innerControl.GetValue(true))
        this.entityObj.SetConfigValue(this.fieldName, val, false)

        if (this.refreshDataOnChange || this.dependentFields && this.dependentFields.Length > 0) {
            this.entityObj.UpdateDataSourceDefaults()
        }

        if (this.dependentFields && this.dependentFields.Length > 0) {
            for index, field in this.dependentFields {
                this.guiObj.guiObj[field].Value := this.entityObj.Config[field]
            }
        }
    }

    AddDependentField(field) {
        this.dependentFields.Push(field)
        return this.dependentFields
    }

    DefaultCheckbox(entity, fieldName) {
        checkedText := !entity.UnmergedConfig.Has(fieldName) ? " Checked" : ""
        checkOpts := this.options.Clone()
        checkOpts := this.SetDefaultOptions(checkOpts, "vDefault" . fieldName . " xs h25 y+" . this.guiObj.margin . checkedText)
        ctl := this.guiObj.guiObj.AddCheckBox(this.GetOptionsString(checkOpts), "Default")
        ctl.ToolTip := "When checked, the default value determined by various other factors in " . this.app.appName . " will be used (and shown to the right if available). When unchecked, the value you set here will be used instead."
        ctl.OnEvent("Click", this.RegisterCallback("OnDefaultCheckbox"))

        return ctl
    }

    OnDefaultCheckbox(chk, info) {
        this.guiObj.Submit(false)
        useDefault := !!(chk.Value)

        if (useDefault) {
            this.entityObj.RevertToDefault(this.fieldName)
            this.SetText((this.entityObj.Config.Has(this.fieldName) && this.entityObj.Config[this.fieldName] != "") ? this.entityObj.Config[this.fieldName] : this.emptyValue)
        } else {
            this.entityObj.UnmergedConfig[this.fieldName] := this.entityObj.Config.Has(this.fieldName) ? this.entityObj.Config[this.fieldName] : ""
        }

        if (this.dependentFields && this.dependentFields.Length > 0) {
            this.entityObj.UpdateDataSourceDefaults()

            for index, field in this.dependentFields {
                this.guiObj.guiObj[field].Value := this.entityObj.Config[field]
            }
        }

        this.ToggleEnabled(!useDefault)
    }

    SetText(text) {
        this.innerControl.SetText(text)
    }

    ToggleEnabled(isEnabled) {
        this.innerControl.ToggleEnabled(isEnabled)
    }
}
