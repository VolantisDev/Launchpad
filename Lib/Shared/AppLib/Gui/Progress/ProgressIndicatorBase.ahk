class ProgressIndicatorBase extends FormGuiBase {
    rangeStart := 0
    rangeStop := 100
    currentPosition := 0
    waitForResult := false
    isDialog := true
    detailText := "Initializing..."
    enableDetailText := true
    cancelCallback := ""

    __New(app, themeObj, windowKey, title, text, owner := "", parent := "", btns := "", rangeStop := "", currentPosition := 0, detailText := true, showInNotificationArea := true) {
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
        
        this.showInNotificationArea := !!(showInNotificationArea)
        super.__New(app, themeObj, windowKey, title, text, owner, parent, btns)
    }

    SetDetailText(detailText) {
        if (this.enableDetailText) {
            this.detailText := detailText
            this.guiObj["DialogDetailText"].Text := detailText
        }
        
    }

    SetProgressIndicator() {
        this.guiObj["DialogStatusIndicator"].Text := this.currentPosition . " / " . this.rangeStop
    }

    SetCancelCallback(callback) {
        this.cancelCallback := callback
    }

    SetRange(start := 0, stop := 100) {
        this.rangeStart := start
        this.rangeStop := stop
    }

    SetValue(value, detailText := false) {
        this.currentPosition := value
        this.SetGuiValue(value)
        this.SetProgressIndicator()

        if (detailText != false) {
            this.SetDetailText(detailText)
        }
    }

    SetGuiValue(value) {
        
    }

    IncrementGuiValue(amount) {

    }

    IncrementValue(amount := 1, detailText := false) {
        this.currentPosition += amount
        this.IncrementGuiValue(amount)
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

        this.AddGuiProgressIndicator()

        this.SetFont("small")
        this.guiObj.AddText("x" . this.margin . " w" . this.windowSettings["contentWidth"] . " Right vDialogStatusIndicator", this.currentPosition . " / " . this.rangeStop)
        this.SetFont()

        if (this.enableDetailText) {
            this.guiObj.AddText("x" . this.margin . " w" . this.windowSettings["contentWidth"] . " vDialogDetailText", this.detailText)
        }
    }

    AddGuiProgressIndicator() {
    
    }

    ProcessResult(result, submittedData := "") {
        if (result != "Cancel") {
            result := this.currentPosition
        }

        return super.ProcessResult(result, submittedData)
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
