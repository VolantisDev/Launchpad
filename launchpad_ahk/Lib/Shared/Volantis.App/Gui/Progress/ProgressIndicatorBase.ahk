class ProgressIndicatorBase extends FormGuiBase {
    currentPosition := 0
    detailText := ""
    cancelCallback := ""

    GetDefaultConfig(container, config) {
        showDetailText := true

        if (config.Has("detailText") && !config["detailText"]) {
            showDetailText := false
        }

        defaults := super.GetDefaultConfig(container, config)
        defaults["waitForResult"] := false
        defaults["detailText"] := "Initializing..."
        defaults["showInNotificationArea"] := true
        defaults["rangeStart"] := 0
        defaults["rangeStop"] := 100
        defaults["startingPosition"] := 0
        defaults["showDetailText"] := !(config.Has("detailText") && !config["detailText"])
        defaults["showStatusIndicator"] := false
        defaults["buttons"] := config.Has("allowCancel") && config["allowCancel"] ? "&Cancel" : ""

        return defaults
    }

    SetDetailText(detailText) {
        if (this.config["showDetailText"]) {
            this.detailText := detailText
            this.guiObj["DialogDetailText"].Text := detailText
        }
        
    }

    SetProgressIndicator() {
        if (this.config["showStatusIndicator"]) {
            this.guiObj["DialogStatusIndicator"].Text := this.currentPosition . " / " . this.config["rangeStop"]
        }
    }

    SetCancelCallback(callback) {
        this.cancelCallback := callback
    }

    SetRange(start := 0, stop := 100) {
        this.config["rangeStart"] := start
        this.config["rangeStop"] := stop
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
        this.currentPosition := this.config["startingPosition"]

        if (this.config["detailText"]) {
            this.detailText := this.config["detailText"]
        }
        
        this.AddGuiProgressIndicator()

        if (this.config["showStatusIndicator"]) {
            this.SetFont("small")
            this.guiObj.AddText("x" . this.margin . " w" . this.windowSettings["contentWidth"] . " Right vDialogStatusIndicator", this.config["startingPosition"] . " / " . this.config["rangeStop"])
            this.SetFont()
        }
        

        if (this.config["showDetailText"]) {
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
