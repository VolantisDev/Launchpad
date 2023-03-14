class LocationEntityFieldWidgetBase extends EntityFieldWidgetBase {
    GetDefaultDefinition(definition) {
        defaults := super.GetDefaultDefinition(definition)
        defaults["controlClass"] := "LocationBlock"
        defaults["extraButton"] := "Clear"
        defaults["extraButtonCallback"] := ObjBindMethod(this, "OnClear")
        defaults["extraButtonOpts"] := ""
        defaults["menuCallback"] := ObjBindMethod(this, "OnLocationMenu")
        defaults["showOpen"] := true
        defaults["controlParams"] := [
            this.fieldId,
            "{{param.extraButton}}",
            "{{param.showOpen}}",
            "{{param.help}}",
            "{{param.extraButtonOpts}}",
            "{{param.menuCallback}}"
        ]
        return defaults
    }

    OnLocationMenuClick(btn) {
        suffix := this.fieldId
        extraName := StrReplace(this["extraButton"], " ", "")

        if (btn == "Change" . suffix) {
            this.ModifyLocation()
        } else if (btn == "Open" . suffix) {
            this.OpenLocation()
        } else if (extraName && btn == extraName . suffix) {
            this.RunCustomCallback(btn)
        }
    }

    ModifyLocation() {
        existingVal := this.GetWidgetValue()

        if existingVal {
            existingVal := "*" . existingVal
        }

        dir := DirSelect(existingVal, 2, "Select the new directory")

        if (dir) {
            this.SetWidgetValue(dir)
        }
    }

    OpenLocation() {
        existingVal := this.GetWidgetValue()

        if (existingVal) {
            Run(existingVal)
        }
    }

    RunCustomCallback(btn) {
        callbackObj := this.Definition["extraButtonCallback"]
            
        if (callbackObj && HasMethod(callbackObj)) {
            callbackObj(btn, this.GetWidgetValue())
        }
    }

    OnClear(ctlObj, info) {
        this.SetWidgetValue("")
    }
}
