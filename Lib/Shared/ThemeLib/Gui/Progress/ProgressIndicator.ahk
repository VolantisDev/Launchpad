class ProgressIndicator extends ProgressIndicatorBase {
    __New(app, themeObj, windowKey, title, text, owner := "", parent := "", allowCancel := false, rangeStop := "", currentPosition := 0, detailText := true, showInNotificationArea := true) {
        btns := allowCancel ? "&Cancel" : ""

        if (windowKey == "") {
            windowKey := "ProgressIndicator"
        }

        super.__New(app, themeObj, windowKey, title, text, owner, parent, btns, rangeStop, currentPosition, detailText, showInNotificationArea)
    }

    SetRange(start := 0, stop := 100) {
        super.SetRange(start, stop)
        this.guiObj["DialogProgress"].Opt("Range" . start . "-" . stop)
    }

    SetGuiValue(value) {
        this.guiObj["DialogProgress"].Value := value
    }

    IncrementGuiValue(amount) {
        this.guiObj["DialogProgress"].Value += amount
    }

    AddGuiProgressIndicator() {
        this.guiObj.AddProgress("x" . this.margin . " w" . this.windowSettings["contentWidth"] . " h5 vDialogProgress c" . this.themeObj.GetColor("accent") . " Background" . this.themeObj.GetColor("accentLight") . " Range" . this.rangeStart . "-" . this.rangeStop, this.currentPosition)
    }
}
