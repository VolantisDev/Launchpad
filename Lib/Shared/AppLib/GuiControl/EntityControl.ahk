class EntityControl extends GuiControlBase {
    innerControl := ""
    defaultCtl := ""
    entityObj := ""
    fieldName := ""
    emptyValue := ""

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
        defaults := ["w" . controlW, defaultX, defaultY]
        opts := this.SetDefaultOptions(this.options, defaults)
        text := (this.entityObj.Config.Has(this.fieldName) && this.entityObj.Config[this.fieldName] != "") ? this.entityObj.Config[this.fieldName] : this.emptyValue
        this.innerControl := this.guiObj.Add(controlClass, this.GetOptionsString(opts), "", text, params*)
        this.ctl := this.innerControl.ctl
        this.ToggleEnabled(!isDisabled)
        return this.innerControl
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

        this.ToggleEnabled(!useDefault)
    }

    SetText(text) {
        this.innerControl.SetText(text)
    }

    ToggleEnabled(isEnabled) {
        this.innerControl.ToggleEnabled(isEnabled)
    }
}
