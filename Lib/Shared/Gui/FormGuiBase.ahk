class FormGuiBase extends GuiBase {
    text := ""
    btns := ""
    result := ""
    waitForResult := true

    __New(title, themeObj, text := "", windowKey := "", owner := "", parent := "", btns := "*&Submit") {
        InvalidParameterException.CheckTypes("FormGuiBase", "btns", btns, "", "text", text, "")
        this.text := text
        this.btns := btns
        super.__New(title, themeObj, windowKey, owner, parent)
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
            position := (A_Index == 1) ? "x" . this.margin . " Section ": "x+m yp "
            defaultOption := InStr(btns[A_Index], "*") ? "Default " : " "
            btn := this.AddButton(position . defaultOption . "w100", RegExReplace(btns[A_Index], "\*"), "OnFormGuiButton")
        }
    }

    OnFormGuiButton(btn, info) {
        this.result := StrReplace(btn.Text, "&")
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
