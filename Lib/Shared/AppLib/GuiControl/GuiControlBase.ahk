class GuiControlBase {
    app := ""
    guiObj := ""
    ctl := ""
    defaultH := 20
    callbacks := Map()

    __New(guiObj, options := "", params*) {
        InvalidParameterException.CheckTypes("GuiControlBase", "guiObj", guiObj, "GuiBase")
        this.app := guiObj.app
        this.guiObj := guiObj
        this.options := this.ParseOptions(options)

        if (this.ctl == "") {
            this.CreateControl(params*)
        }
    }

    RegisterCallback(funcName) {
        this.callbacks[funcName] := ObjBindMethod(this, funcName)
        return this.callbacks[funcName]
    }

    CreateControl(params*) {
        
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
                opts := StrSplit(options, [A_Tab, A_Space], " `t")
            }
        }

        return opts
    }

    AddHeading(text, options := "") {
        options := this.ParseOptions(options)
        options := this.SetDefaultOptions(options, ["Section", "+0x200", "y+" . (this.guiObj.margin)])
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

        for index, option in defaults {
            firstChar := SubStr(option, 1, 1)

            if (firstChar == "x" || firstChar == "y" || firstChar == "w" || firstChar == "h") {
                if (!this.GetOptionIndex(options, firstChar)) {
                    options.Push(option)
                }
            }
        }

        return options
    }

    GetOptionIndex(options, key) {
        result := 0

        for index, option in options {
            firstChar := SubStr(option, 1, 1)
            test := (firstChar == "+" || firstChar == "-") ? SubStr(option, 2, 1) : option
            len := StrLen(key)

            if (SubStr(test, 1, len) == key) {
                result := index
                break
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
}
