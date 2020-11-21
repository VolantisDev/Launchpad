class ProgressIndicator extends DialogBox {
    progressRange := "0-100"
    initialPosition := 0
    waitForResult := false
    detailText := ""
    enableDetailText := true
    cancelCallback := ""

    __New(app, title, text, owner := "", allowCancel := false, progressRange := "0-100", initialPosition := 0, detailText := true) {
        this.progressRange := progressRange
        this.initialPosition := initialPosition
        this.enableDetailText := (detailText != false)

        if (detailText != true and detailText != false) {
            this.detailText := detailText
        }

        buttons := allowCancel ? "&Cancel" : ""

        super.__New(app, title, text, owner, buttons)
    }

    SetDetailText(detailText) {
        this.detailText := detailText
        this.guiObj["DialogDetailText"].Text := detailText
    }

    SetCancelCallback(callback) {
        this.cancelCallback := callback
    }

    SetRange(range) {
        this.guiObj["DialogProgress"].Opt("Range" . range)
    }

    SetValue(value, detailText := false) {
        this.guiObj["DialogProgress"].Value := value

        if (detailText != false) {
            this.SetDetailText(detailText)
        }
    }
    
    Finish() {
        result := this.ProcessResult("OK")
        this.Close()
        this.Destroy()
        return result
    }

    Controls(posY) {
        posY := super.Controls(posY)

        this.guiObj.AddProgress("x" . this.margin . " y" . posY . " w" . this.contentWidth . " h20 vDialogProgress c9466FC BackgroundEEE6FF Range" . this.progressRange, this.initialPosition)
        posY += 20 + this.margin

        if (this.enableDetailText) {
            this.guiObj.AddText("x" . this.margin . " y" . posY . " w" . this.contentWidth . " h20 vDialogDetailText", this.detailText)
            posY += 20 + this.margin
        }

        return posY
    }

    ProcessResult(result) {
        if (result != "Cancel") {
            result := this.guiObj["DialogProgress"].Value
        }

        return super.ProcessResult(result)
    }

    OnDialogBoxButton(btn, info) {
        btn := super.OnDialogBoxButton(btn)
        this.result := StrReplace(btn.Text, "&")

        if (this.result == "Cancel") {
            if (this.cancelCallback) {
                this.cancelCallback.Call(this)
            }

            this.OnCancel(this.guiObj)
        }
    }
}
