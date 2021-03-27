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
            this.guiObj.AddText("w" . this.windowSettings["contentWidth"] . "", this.text)
        }
    }

    End() {
        super.End()
        result := ""

        if (this.waitForResult) {
            Loop
            {
                If (this.result) {
                    Break
                }

                Sleep(50)
            }

            this.Submit()
            result := this.ProcessResult(this.result)
            this.Close()
        } else {
            result := this
        }

        return result
    }

    AddButtons() {
        super.AddButtons()

        btns := StrSplit(this.btns, "|")

        loop btns.Length {
            position := (A_Index == 1) ? "xm " : "x+m yp "
            ;defaultOption := InStr(btns[A_Index], "*") ? "Default " : " "
            defaultOption := " "
            btn := this.AddButton(position . defaultOption . "w100 h30", RegExReplace(btns[A_Index], "\*"), "OnFormGuiButton")
        }
    }

    OnFormGuiButton(btn, info) {
        btnText := this.themeObj.themedButtons.Has(btn.Hwnd) ? this.themeObj.themedButtons[btn.Hwnd]["content"] : "OK"
        this.result := StrReplace(btnText, "&")
    }

    ProcessResult(result) {
        return result
    }

    OnClose(guiObj) {
        this.result := "Close"
        super.OnClose(guiObj)
    }

    OnEscape(guiObj) {
        this.result := "Close"
        super.OnClose(guiObj)
    }
}
