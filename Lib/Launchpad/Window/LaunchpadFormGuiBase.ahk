class LaunchpadFormGuiBase extends FormGuiBase {
    app := ""
    
    __New(app, title, text := "", windowKey := "", owner := "", parent := "", btns := "*&Submit") {
        InvalidParameterException.CheckTypes("LaunchpadFormGuiBase", "app", app, "Launchpad")
        this.app := app

         if (Type(owner) == "String") {
            owner := app.Windows.GetGuiObj(owner)
        }

        if (Type(parent) == "String") {
            parent := app.Windows.GetGuiObj(parent)
        }
        
        super.__New(title, app.Themes.GetItem(), text, windowKey, owner, parent, btns)
    }

    AddComboBox(heading, field, currentValue, allItems, helpText := "") {
        this.AddHeading(heading)
        ctl := this.guiObj.AddComboBox("v" . field . " xs y+m w" . this.windowSettings["contentWidth"], allItems)
        ctl.Text := currentValue
        ctl.OnEvent("Change", "On" . field . "Change")

        if (helpText) {
            ctl.ToolTip := helpText
        }
    }

    AddEntityTypeSelect(heading, field, currentValue, allItems, buttonName := "", helpText := "") {
        return this.AddSelect(heading, field, currentValue,  allItems, false, buttonName, "Manage", helpText, false)
    }

    AddSelect(heading, field, currentValue, allItems, showDefaultCheckbox := false, buttonName := "", buttonText := "", helpText := "", addPrefix := false) {
        this.AddHeading(heading)

        checkW := 0
        buttonW := buttonName ? 150 : 0
        disabledText := ""

        prefixedName := field
        if (addPrefix) {
            prefixedName := this.entityObj.configPrefix . field
        }

        if (showDefaultCheckbox) {
            disabledText := this.entityObj.UnmergedConfig.Has(prefixedName) ? "" : " Disabled"
            ctl := this.DefaultCheckbox(field, "", addPrefix)
            ctl.GetPos(,,checkW)
        }
        
        fieldW := this.windowSettings["contentWidth"]

        if (checkW) {
            fieldW := fieldW - checkW - this.margin
        }

        if (buttonW) {
            fieldW := fieldW - buttonW - this.margin
        }

        chosen := this.GetItemIndex(allItems, currentValue)
        pos := showDefaultCheckbox ? "x+m yp" : "xs y+m"
        pos := pos . disabledText
        ctl := this.guiObj.AddDDL("v" . field . " " . pos . " Choose" . chosen . " w" . fieldW, allItems)
        ctl.OnEvent("Change", "On" . field . "Change")

        if (buttonName) {
            this.AddButton("v" . buttonName . " x+m yp w" . buttonW . " h25", buttonText, "On" . buttonName)
        }

        if (helpText) {
            ctl.ToolTip := helpText
        }
    }

    DefaultCheckbox(fieldKey, entity, addPrefix := false) {
        prefixedName := fieldKey
        if (addPrefix) {
            prefixedName := entity.configPrefix . prefixedName
        }

        checkedText := !entity.UnmergedConfig.Has(prefixedName) ? " Checked" : ""
        ctl := this.guiObj.AddCheckBox("vDefault" . fieldKey . " xs h25 y+m" . checkedText, "Default")
        ctl.ToolTip := "When checked, the default value determined by various other factors in Launchpad will be used (and shown to the right if available). When unchecked, the value you set here will be used instead."
        ctl.OnEvent("Click", "OnDefault" . fieldKey)
        return ctl
    }
}
