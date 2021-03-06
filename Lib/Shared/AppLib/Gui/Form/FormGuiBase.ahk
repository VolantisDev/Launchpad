class FormGuiBase extends GuiBase {
    text := ""
    btns := ""
    result := ""
    waitForResult := true
    buttonNames := []

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

        btnW := 90
        btnH := 28
        btnsW := (btnW * btns.Length) + (this.margin * (btns.Length - 1))
        btnsStart := this.margin + this.windowSettings["contentWidth"] - btnsW

        loop btns.Length {
            position := (A_Index == 1) ? "x" . btnsStart " " : "x+m yp "
            ;defaultOption := InStr(btns[A_Index], "*") ? "Default " : " "
            defaultOption := " "
            btnText := RegExReplace(btns[A_Index], "\*")
            btnName := "Button" . StrReplace(btnText, " ", "")
            this.buttonNames.Push(btnName)
            this.Add("ButtonControl", position . defaultOption . "w" . btnW . " h" . btnH . " v" . btnName, btnText, "OnFormGuiButton", "dialog")
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
