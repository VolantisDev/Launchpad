class FormGuiBase extends GuiBase {
    result := ""
    buttonNames := []

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["buttons"] := "*&Submit"
        defaults["text"] := ""
        defaults["waitForResult"] := true
        defaults["unique"] := false
        return defaults
    }

    /**
    * IMPLEMENTED METHODS
    */

    Controls() {
        super.Controls()

        if (this.config["text"] != "") {
            this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . " Section", this.config["text"])
        }
    }

    AddButtons() {
        super.AddButtons()

        btns := StrSplit(this.config["buttons"], "|")
        btnW := 90
        btnH := 28
        btnsW := (btnW * btns.Length) + (this.margin * (btns.Length - 1))
        btnsStart := this.margin + this.windowSettings["contentWidth"] - btnsW

        loop btns.Length {
            btnText := RegExReplace(btns[A_Index], "\*")
            btnName := "Button" . StrReplace(btnText, " ", "")
            btnName := StrReplace(btnName, "&", "")
            btnName := StrReplace(btnName, "*", "")

            this.buttonNames.Push(btnName)

            opts := [
                A_Index == 1 ? "x" . btnsStart : "x+" . this.margin,
                "w" . btnW,
                "h" . btnH,
                "v" . btnName
            ]

            if (A_Index > 1) {
                opts.Push("yp")
            }

            this.Add("ButtonControl", opts, btnText, "OnFormGuiButton", "dialog")
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

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)

        this.AutoXYWH("xy", this.buttonNames)
    }
}
