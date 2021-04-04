class EditControl extends GuiControlBase {
    lineSeparator := ""
    rows := 3

    CreateControl(value, rows := 1, lineSeparator := "", helpText := "") {
        super.CreateControl()

        if (rows > 1 && lineSeparator == "") {
            lineSeparator := ";"
        }

        this.lineSeparator := lineSeparator
        this.rows := rows
        defaults := ["c" . this.guiObj.themeObj.GetColor("editText")]

        if (this.rows > 1) {
            defaults.Push("r" . this.rows)
        }

        opts := this.SetDefaultOptions(this.options, defaults)
        this.ctl := this.guiObj.guiObj.Add("Edit", this.GetOptionsString(this.options), value)

        if (helpText) {
            this.ctl.ToolTip := helpText
        }

        return this.ctl
    }

    GetValue(submit := false) {
        value := super.GetValue(submit)

        if (this.lineSeparator) {
            value := StrReplace(value, "`r`n", this.lineSeparator)
            value := StrReplace(value, "`n", this.lineSeparator)
        }

        return value
    }
}
