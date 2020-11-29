class FormGuiBase extends GuiBase {
    text := ""
    btns := ""
    contentWidth := 320
    windowOptions := "+Toolwindow +AlwaysOnTop"
    result := ""
    waitForResult := true

    __New(title, text := "", owner := "", windowKey := "", btns := "*&Submit") {
        this.text := text
        this.btns := btns
        super.__New(title, owner, windowKey)
    }

    Controls() {
        super.Controls()

        if (this.text != "") {
            this.guiObj.AddText("w" . this.contentWidth . "", this.text)
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
            position := (A_Index == 1) ? "x" . this.windowMargin . " Section ": "x+m yp "
            defaultOption := InStr(btns[A_Index], "*") ? "Default " : " "
            btn := this.guiObj.AddButton(position . defaultOption . "w100", RegExReplace(btns[A_Index], "\*"))
            btn.OnEvent("Click", "OnFormGuiButton")
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
