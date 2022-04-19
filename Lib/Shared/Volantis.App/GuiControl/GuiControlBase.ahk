class GuiControlBase {
    app := ""
    guiObj := ""
    ctl := ""
    defaultH := 20
    callbacks := Map()
    parameters := ""
    heading := ""
    changeCallback := ""
    resizeOpts := ""

    __New(guiObj, options := "", heading := "", params*) {
        InvalidParameterException.CheckTypes("GuiControlBase", "guiObj", guiObj, "GuiBase")
        this.app := guiObj.app
        this.guiObj := guiObj

        if (HasBase(options, GuiControlParameters.Prototype)) {
            parameters := options
        } else {
            parameters := GuiControlParameters()

            if (options) {
                parameters.SetOptions(options)
            }
        }

        if (!parameters.Has("contentWidth") || !parameters["contentWidth"]) {
            parameters["contentWidth"] := guiObj.windowSettings["contentWidth"]
        }

        this.parameters := parameters
        this.heading := heading

        if (this.ctl == "") {
            this.CreateControl(params*)
        }
    }

    RegisterCallback(funcName) {
        this.callbacks[funcName] := ObjBindMethod(this, funcName)
        return this.callbacks[funcName]
    }

    CreateControl(showHeading := true, params*) {
        if showHeading && this.heading {
            this.AddHeading(this.heading)
        } 
    }

    GetCtl() {
        return this.ctl
    }

    AddHeading(text, options := "") {
        options := this.parameters.applyDefaults(options, [
            "Section", 
            "+0x200", 
            "y+" . (this.guiObj.margin*1.5),
            "w" . this.parameters["contentWidth"]
        ])

        this.guiObj.SetFont("normal", "Bold")
        ctl := this.guiObj.guiObj.AddText(this.parameters.GetOptionsString(options, "", true, false), text)
        this.guiObj.SetFont()

        return ctl
    }

    AddText(text, options := "") {
        options := this.parameters.applyDefaults(options, [
            "+0x200",
            "w" . this.parameters["contentWidth"]
        ])

        return this.guiObj.guiObj.AddText(this.parameters.GetOptionsString(options), text)
    }

    SetValue(value) {
        this.SetText(value)
    }

    SetText(text) {
        if (this.ctl) {
            if (this.ctl.Type == "CheckBox") {
                this.ctl.Value := !!(text)
            } else {
                this.ctl.Value := text
            }
        }
    }

    GetValue(submit := false) {
        if (submit) {
            this.guiObj.guiObj.Submit(false)
        }

        value := ""

        if (this.ctl) {
            if (this.ctl.Type == "CheckBox") {
                value := !!(this.ctl.Value)
            } else if (this.ctl.Type == "DDL" || this.ctl.Type == "ComboBox" || this.ctl.Type == "Edit") {
                value := this.ctl.Text
            } else {
                value := this.ctl.Value
            }
        }

        return value
    }

    ToggleEnabled(isEnabled) {
        if (this.ctl.Type != "Text") {
            this.ctl.Enabled := !!(isEnabled)
        }
    }

    RegisterHandler(eventName, handler) {
        if (this.ctl) {
            if (eventName == "Change") {
                if (this.SupportsChangeEvent()) {
                    if (this.ctl.Type == "CheckBox") {
                        eventName := "Click"
                    }
                    this.ctl.OnEvent(eventName, handler)
                }
            } else {
                this.ctl.OnEvent(eventName, handler)
            }
        }
        
    }

    SupportsChangeEvent() {
        return this.ctl && this.ctl.Type != "Button" && this.ctl.Type != "Text"
    }

    SubclassControl(hctl, callback, data := 0) {
        static controlCB := Map()

        If controlCB.Has(hctl) {
            DllCall("RemoveWindowSubclass", "Ptr", hctl, "Ptr", controlCB[hctl], "Ptr", hctl)
            DllCall("GlobalFree", "Ptr", controlCB[hctl], "Ptr")
            controlCB.Delete(hctl)

            If (callback = "") {
                return true
            }
        }

        if (!DllCall("IsWindow", "Ptr", hctl, "UInt")) {
            return false
        }

        if (!(CB := CallbackCreate(callback, , 6))) {
            return false
        }
            
        If !DllCall("SetWindowSubclass", "Ptr", hctl, "Ptr", CB, "Ptr", hctl, "Ptr", data) {
            return (DllCall("GlobalFree", "Ptr", CB, "Ptr") & 0)
        }
            
        return (controlCB[hctl] := CB)
    }

    OnSize(guiObj, minMax, width, height) {
        if (minMax == -1) {
            return
        }

        if (this.resizeOpts) {
            this.guiObj.AutoXYWH(this.resizeOpts, [this.ctl.Name])
        }
    }
}
