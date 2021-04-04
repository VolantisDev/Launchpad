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
