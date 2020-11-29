class ProgressIndicator extends DialogBox {
    rangeStart := 0
    rangeStop := 100
    currentPosition := 0
    waitForResult := false
    detailText := ""
    enableDetailText := true
    cancelCallback := ""

    __New(title, text, owner := "", allowCancel := false, rangeStop := "", currentPosition := 0, detailText := true) {
        if (rangeStop != "") {
            this.rangeStop := rangeStop
        }

        this.currentPosition := currentPosition
        this.enableDetailText := (detailText != false)

        if (detailText != true and detailText != false) {
            this.detailText := detailText
        }

        btns := allowCancel ? "&Cancel" : ""

        super.__New(title, text, owner, btns)
    }

    SetDetailText(detailText) {
        this.detailText := detailText
        this.guiObj["DialogDetailText"].Text := detailText
    }

    SetProgressIndicator() {
        ;this.guiObj.SetFont("s9")
        this.guiObj["DialogStatusIndicator"].Text := this.currentPosition . " / " . this.rangeStop
        ;this.ResetFont()
    }

    SetCancelCallback(callback) {
        this.cancelCallback := callback
    }

    SetRange(start := 0, stop := 100) {
        this.rangeStart := start
        this.rangeStop := stop
        this.guiObj["DialogProgress"].Opt("Range" . start . "-" . stop)
    }

    SetValue(value, detailText := false) {
        this.currentPosition := value
        this.guiObj["DialogProgress"].Value := value

        this.SetProgressIndicator()

        if (detailText != false) {
            this.SetDetailText(detailText)
        }
    }

    IncrementValue(amount := 1, detailText := false) {
        this.currentPosition += amount
        this.guiObj["DialogProgress"].Value += amount

        this.SetProgressIndicator()

        if (detailText != false) {
            this.SetDetailText(detailText)
        }
    }
    
    Finish() {
        result := this.ProcessResult("OK")
        this.Close()
        return result
    }

    Controls() {
        super.Controls()

        this.guiObj.AddProgress("x" . this.windowMargin . " w" . this.contentWidth . " h5 vDialogProgress c9466FC BackgroundEEE6FF Range" . this.rangeStart . "-" . this.rangeStop, this.currentPosition)

        this.guiObj.SetFont("s9")
        this.guiObj.AddText("x" . this.windowMargin . " w" . this.contentWidth . " Right vDialogStatusIndicator", this.currentPosition . " / " . this.rangeStop)
        this.ResetFont()

        if (this.enableDetailText) {
            this.guiObj.AddText("x" . this.windowMargin . " w" . this.contentWidth . " vDialogDetailText", this.detailText)
        }
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
