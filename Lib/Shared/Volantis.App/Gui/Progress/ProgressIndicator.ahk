class ProgressIndicator extends ProgressIndicatorBase {
    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["buttons"] := config.Has("allowCancel") && config["allowCancel"] ? "&Cancel" : ""
        return defaults
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
        this.guiObj.AddProgress("x" . this.margin . " w" . this.windowSettings["contentWidth"] . " h5 vDialogProgress c" . this.themeObj.GetColor("progressBarFg") . " Background" . this.themeObj.GetColor("progressBarBg") . " Range" . this.config["rangeStart"] . "-" . this.config["rangeStop"], this.currentPosition)
    }
}
