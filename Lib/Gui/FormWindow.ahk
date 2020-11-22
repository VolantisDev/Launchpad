class FormWindow extends GuiBase {
    text := ""
    buttons := ""
    contentWidth := 320
    windowOptions := "+Toolwindow +AlwaysOnTop"
    result := ""
    waitForResult := true

    __New(app, title, text := "", owner := "", windowKey := "", buttons := "*&Yes|&No") {
        this.text := text
        this.buttons := buttons
        super.__New(app, title, owner, windowKey)
    }

    Controls(posY) {
        posY := super.Controls(posY)
        height := 40

        if (this.text != "") {
            this.guiObj.AddText("x" . this.margin . " y" . posY . " w" . this.contentWidth . " h" . height, this.text)
            posY += height + this.margin
        }
        
        return posY
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

    AddButtons(posY) {
        super.AddButtons(posY)
        buttons := StrSplit(this.buttons, "|")

        loop buttons.Length {
            position := (A_Index == 1) ? "x" . this.margin . " y" . posY . " ": "x+" . this.margin . " y" . posY . " "
            defaultOption := InStr(buttons[A_Index], "*") ? "Default " : " "
            btn := this.guiObj.AddButton(position . defaultOption . "w100", RegExReplace(buttons[A_Index], "\*"))
            btn.OnEvent("Click", "OnFormWindowButton")
        }
    }

    OnFormWindowButton(btn, info) {
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
