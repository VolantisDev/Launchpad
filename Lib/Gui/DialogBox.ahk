class DialogBox extends Gui {
    text := ""
    buttons := ""
    label := "DialogBox"
    contentWidth := 320
    windowOptions := "+Toolwindow +AlwaysOnTop"

    __New(app, title, text, owner := 0, buttons := "*&Yes|&No") {
        this.text := text
        this.buttons := buttons
        base.__New(app, title, owner)
    }

    Controls(posY) {
        global DialogBox_Result

        DialogBox_Result := ""

        posY := base.Controls(posY)
        width := this.contentWidth
        margin := this.margin
        height := 40
        guiLabel := this.label

        Gui, %guiLabel%:Add, Text, x%margin% y%posY% w%width% h%height%, % this.text
        posY += height + this.margin

        return posY
    }

    End() {
        global DialogBox_Result

        base.End()

        Loop
        {
            If (DialogBox_Result) {
                Break
            }
        }

        this.Close()
        result := this.ProcessResult(DialogBox_Result)
        this.Destroy()

        return result
    }

    AddButtons(posY) {
        base.AddButtons(posY)

        guiLabel := this.label
        buttons := StrSplit(this.buttons, "|")

        Loop % buttons.MaxIndex()
        {
            position := (A_Index == 1) ? "x" . this.margin . " y" . posY . " ": "x+" . this.margin . " y" . posY . " "
            defaultOption := InStr(buttons[A_Index], "*") ? "Default " : " "
            Gui %guiLabel%:Add, Button, % position . defaultOption . "w100 gDialogBoxButton", % RegExReplace(buttons[A_Index], "\*")
        }
    }

    ProcessResult(result) {
        return result
    }

    Cleanup() {
        global DialogBox_Result

        DialogBox_Result := ""

        base.Cleanup()
    }
}

DialogBoxGuiEscape:
DialogBoxGuiClose:
{
    ;DialogBox_Result := "Close"
    Return
}

DialogBoxButton:
{
    StringReplace, DialogBox_Result, A_GuiControl, &,, All
    Return
}
