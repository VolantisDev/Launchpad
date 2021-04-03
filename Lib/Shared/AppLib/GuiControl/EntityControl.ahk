class EntityControl extends GuiControlBase {
    innerControl := ""
    defaultCtl := ""
    entityObj := ""
    prefixedName := ""
    emptyValue := ""

    CreateControl(entity, fieldName, heading, addPrefix, params*) {
        if (entity == "") {
            entity := this.guiObj.entityObj
        }

        this.entityObj := entity

        if (heading) {
            this.AddHeading(heading)
        }

        checkW := 0
        prefixedName := fieldName

        if (addPrefix) {
            prefixedName := entity.configPrefix . prefixedName
        }

        this.prefixedName := prefixedName
        ctl := this.DefaultCheckbox(entity, fieldName)
        this.defaultCtl := ctl
        ctl.GetPos(,,checkW)
        isDisabled := !entity.UnmergedConfig.Has(prefixedName)
        defaults := ["w" . this.guiObj.windowSettings["contentWidth"] - checkW - this.guiObj.margin, "x+" . this.guiObj.margin, "yp"]
        params[2] := this.GetOptionsString(this.SetDefaultOptions(params[2], defaults))
        this.innerControl := this.guiObj.Add(params*)
        this.ctl := this.innerControl.ctl
        this.ToggleEnabled(!isDisabled)
        this.SetText((this.entityObj.Config.Has(this.prefixedName) && this.entityObj.Config[this.prefixedName] != "") ? this.entityObj.Config[this.prefixedName] : this.emptyValue)
        return this.innerControl
    }

    DefaultCheckbox(entity, fieldName, includePrefixInName := false) {
        prefixedName := this.prefixedName
        ctlKey := includePrefixInName ? prefixedName : fieldName

        checkedText := !entity.UnmergedConfig.Has(prefixedName) ? " Checked" : ""
        checkOpts := this.options.Clone()
        checkOpts := this.SetDefaultOptions(checkOpts, "vDefault" . ctlKey . " xs h25 y+" . this.guiObj.margin . checkedText)
        ctl := this.guiObj.guiObj.AddCheckBox(this.GetOptionsString(checkOpts), "Default")
        ctl.ToolTip := "When checked, the default value determined by various other factors in " . this.app.appName . " will be used (and shown to the right if available). When unchecked, the value you set here will be used instead."
        ctl.OnEvent("Click", this.RegisterCallback("OnDefaultCheckbox"))
        return ctl
    }

    OnDefaultCheckbox(chk, info) {
        this.guiObj.Submit(false)
        useDefault := !!(chk.Value)

        if (useDefault) {
            this.entityObj.RevertToDefault(this.prefixedName)
            this.SetText((this.entityObj.Config.Has(this.prefixedName) && this.entityObj.Config[this.prefixedName] != "") ? this.entityObj.Config[this.prefixedName] : this.emptyValue)
        } else {
            this.entityObj.UnmergedConfig[this.prefixedName] := this.entityObj.Config.Has(this.prefixedName) ? this.entityObj.Config[this.prefixedName] : ""
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
