class ProgressIndicator extends FormGuiBase {
    rangeStart := 0
    rangeStop := 100
    currentPosition := 0
    waitForResult := false
    isDialog := true
    detailText := "Initializing..."
    enableDetailText := true
    cancelCallback := ""

    __New(title, themeObj, text, owner := "", allowCancel := false, rangeStop := "", currentPosition := 0, detailText := true, showInNotificationArea := true) {
        if (rangeStop != "") {
            InvalidParameterException.CheckTypes("ProgressIndicator", "rangeStop", rangeStop, "Integer")
            this.rangeStop := rangeStop
        }

        if (currentPosition != "") {
            InvalidParameterException.CheckTypes("ProgressIndicator", "currentPosition", currentPosition, "Integer")
            InvalidParameterException.CheckBetween("ProgressIndicator", "currentPosition", currentPosition, this.rangeStart, this.RangeStop)
        }

        this.currentPosition := currentPosition
        this.enableDetailText := !!(detailText)

        if (Type(detailText) == "String") {
            this.detailText := detailText
        }
        
        btns := allowCancel ? "&Cancel" : ""
        this.showInNotificationArea := !!(showInNotificationArea)
        super.__New(title, themeObj, text, owner, "", btns)
    }

    SetDetailText(detailText) {
        if (this.enableDetailText) {
            this.detailText := detailText
            this.guiObj["DialogDetailText"].Text := detailText
        }
        
    }

    SetProgressIndicator() {
        ;this.guiObj.SetFont("s9")
        this.guiObj["DialogStatusIndicator"].Text := this.currentPosition . " / " . this.rangeStop
        ;this.SetFont()
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

        this.guiObj.AddProgress("x" . this.margin . " w" . this.windowSettings["contentWidth"] . " h5 vDialogProgress c9466FC BackgroundEEE6FF Range" . this.rangeStart . "-" . this.rangeStop, this.currentPosition)

        this.guiObj.SetFont("s9")
        this.guiObj.AddText("x" . this.margin . " w" . this.windowSettings["contentWidth"] . " Right vDialogStatusIndicator", this.currentPosition . " / " . this.rangeStop)
        this.SetFont()

        if (this.enableDetailText) {
            this.guiObj.AddText("x" . this.margin . " w" . this.windowSettings["contentWidth"] . " vDialogDetailText", this.detailText)
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
