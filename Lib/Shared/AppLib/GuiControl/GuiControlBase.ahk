class GuiControlBase {
    app := ""
    guiObj := ""
    ctl := ""
    defaultH := 20
    callbacks := Map()
    options := ""
    heading := ""
    changeCallback := ""

    __New(guiObj, options := "", heading := "", params*) {
        InvalidParameterException.CheckTypes("GuiControlBase", "guiObj", guiObj, "GuiBase")
        this.app := guiObj.app
        this.guiObj := guiObj
        this.options := this.ParseOptions(options)
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

    ParseOptions(options) {
        isMap := Type(options) == "Map"
        isArray := Type(options) == "Array"
        opts := isArray ? options : []

        if (options && !isArray) {
            if (isMap) {
                for key, val in options {
                    if (val == true) {
                        opts.Push("+" . key)
                    } else if (val == false) {
                        opts.Push("-" . key)
                    } else {
                        opts.Push(key . val)
                    }
                }
            } else {
                opts := StrSplit(options, " ", " `t")
            }
        }

        return opts
    }

    AddHeading(text, options := "") {
        options := this.ParseOptions(options)
        options := this.SetDefaultOptions(options, ["Section", "+0x200", "y+" . (this.guiObj.margin*1.5)])
        options := this.SetDefaultPosition(options, true)

        this.guiObj.SetFont("normal", "Bold")
        ctl := this.guiObj.guiObj.AddText(this.GetOptionsString(options), text)
        this.guiObj.SetFont()

        return ctl
    }

    AddText(text, options := "") {
        options := this.ParseOptions(options)
        options := this.SetDefaultOptions(options, ["+0x200"])
        options := this.SetDefaultPosition(options, true)

        return this.guiObj.guiObj.AddText(this.GetOptionsString(options), text)
    }

    GetOptionsString(options) {
        str := ""

        for index, option in options {
            if (str) {
                str .= " "
            }

            str .= option
        }

        return str
    }

    SetDefaultPosition(options, needsW := true, needsH := false) {
        defaults := ["x" . this.guiObj.margin, "y+" . this.guiObj.margin]

        if (needsW) {
            defaults.Push("w" . this.guiObj.windowSettings["contentWidth"])
        }

        if (needsH) {
            defaults.Push("h", this.defaultH)
        }

        return this.SetDefaultOptions(options, defaults)
    }

    SetDefaultOptions(options, defaults) {
        isPos := false

        if (Type(options) != "Array") {
            options := this.ParseOptions(options)
        }

        if (Type(defaults) == "String") {
            defaults := this.ParseOptions(defaults)
        }

        for index, option in defaults {
            firstChar := SubStr(option, 1, 1)

            if (firstChar == "x" || firstChar == "y" || firstChar == "w" || firstChar == "h") {
                if (!this.GetOptionIndex(options, firstChar)) {
                    options.Push(option)
                }
            } else {
                if (!this.GetOptionIndex(options, option)) {
                    options.Push(option)
                }
            }
        }

        return options
    }

    GetOptionIndex(options, key) {
        result := 0

        if (Type(options) == "Array") {
            for index, option in options {
                firstChar := SubStr(option, 1, 1)
                test := (firstChar == "+" || firstChar == "-") ? SubStr(option, 2, 1) : option
                len := StrLen(key)

                if (SubStr(test, 1, len) == key) {
                    result := index
                    break
                }
            }
        }
        

        return result
    }

    GetOption(options, key) {
        index := this.GetOptionIndex(options, key)
        option := ""

        if (index) {
            option := options[index]
        }

        return option
    }

    RemoveOption(options, key) {
        index := this.GetOptionIndex(options, key)

        if (index) {
            options.RemoveAt(index)
        }

        return options
    }

    SetOption(options, key, val := "") {
        opt := key

        if (val != "") {
            opt .= val
        }

        options := this.RemoveOption(options, key)
        options.Push(opt)
        return options
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

    }
}
