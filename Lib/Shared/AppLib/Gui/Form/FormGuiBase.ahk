class FormGuiBase extends GuiBase {
    text := ""
    btns := ""
    result := ""
    waitForResult := true

    __New(app, themeObj, windowKey, title, text := "", owner := "", parent := "", btns := "*&Submit") {
        this.text := text
        this.btns := btns
        super.__New(app, themeObj, windowKey, title, owner, parent)
    }

    /**
    * IMPLEMENTED METHODS
    */

    Controls() {
        super.Controls()

        if (this.text != "") {
            this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " Section", this.text)
        }
    }

    AddButtons() {
        super.AddButtons()

        btns := StrSplit(this.btns, "|")

        btnW := 100
        btnsW := (btnW * btns.Length) + (this.margin * (btns.Length - 1))
        btnsStart := this.margin + this.windowSettings["contentWidth"] - btnsW

        loop btns.Length {
            position := (A_Index == 1) ? "x" . btnsStart " " : "x+m yp "
            ;defaultOption := InStr(btns[A_Index], "*") ? "Default " : " "
            defaultOption := " "
            this.Add("ButtonControl", position . defaultOption . "w100 h30", RegExReplace(btns[A_Index], "\*"), "OnFormGuiButton", "dialog")
        }
    }

    OnFormGuiButton(btn, info) {
        btnText := this.themeObj.themedButtons.Has(btn.Hwnd) ? this.themeObj.themedButtons[btn.Hwnd]["content"] : "OK"
        this.result := StrReplace(btnText, "&")
    }

    OnClose(guiObj) {
        this.result := "Close"
        super.OnClose(guiObj)
    }

    OnEscape(guiObj) {
        this.result := "Close"
        super.OnClose(guiObj)
    }

    AddComboBox(heading, field, currentValue, allItems, helpText := "") {
        this.AddHeading(heading)
        ctl := this.guiObj.AddComboBox("v" . field . " xs y+m w" . this.windowSettings["contentWidth"] . " c" . this.themeObj.GetColor("editText"), allItems)
        ctl.Text := currentValue
        ctl.OnEvent("Change", "On" . field . "Change")

        if (helpText) {
            ctl.ToolTip := helpText
        }
    }

    AddEntityTypeSelect(heading, field, currentValue, allItems, buttonName := "", helpText := "", showManage := true) {
        return this.AddSelect(heading, field, currentValue,  allItems, false, buttonName, showManage ? "Manage" : "", helpText, false)
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
        ctl := this.guiObj.AddDDL("v" . field . " " . pos . " Choose" . chosen . " w" . fieldW . " c" . this.themeObj.GetColor("editText"), allItems)
        ctl.OnEvent("Change", "On" . field . "Change")

        if (buttonName) {
            this.Add("ButtonControl", "v" . buttonName . " x+m yp w" . buttonW . " h25", buttonText, "On" . buttonName)
        }

        if (helpText) {
            ctl.ToolTip := helpText
        }
    }

    DefaultCheckbox(fieldKey, entity, addPrefix := false, includePrefixInCtlName := false) {
        prefixedName := fieldKey
        if (addPrefix) {
            prefixedName := entity.configPrefix . prefixedName
        }

        ctlKey := includePrefixInCtlName ? prefixedName : fieldKey

        checkedText := !entity.UnmergedConfig.Has(prefixedName) ? " Checked" : ""
        ctl := this.guiObj.AddCheckBox("vDefault" . ctlKey . " xs h25 y+m" . checkedText, "Default")
        ctl.ToolTip := "When checked, the default value determined by various other factors in " . this.app.appName . " will be used (and shown to the right if available). When unchecked, the value you set here will be used instead."
        ctl.OnEvent("Click", "OnDefault" . ctlKey)
        return ctl
    }
}
