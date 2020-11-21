#Include GuiBase.ahk

class DialogBox extends GuiBase {
    text := ""
    buttons := ""
    contentWidth := 320
    windowOptions := "+Toolwindow +AlwaysOnTop"
    result := ""
    waitForResult := true

    __New(app, title, text, owner := "", buttons := "*&Yes|&No") {
        this.text := text
        this.buttons := buttons
        super.__New(app, title, owner)
    }

    Controls(posY) {
        posY := super.Controls(posY)
        height := 40
        this.guiObj.AddText("x" . this.margin . " y" . posY . " w" . this.contentWidth . " h" . height, this.text)
        posY += height + this.margin
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

            this.Close(true)
            result := this.ProcessResult(this.result)
            this.Destroy()
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
            btn.OnEvent("Click", "OnDialogBoxButton")
        }
    }

    OnDialogBoxButton(btn, info) {
        this.result := StrReplace(btn.Text, "&")
    }

    ProcessResult(result) {
        return result
    }

    OnClose(guiObj) {
        DialogBox_Result := "Close"
        super.OnClose(guiObj)
    }

    OnEscape(guiObj) {
        DialogBox_Result := "Close"
        super.OnClose(guiObj)
    }
}
