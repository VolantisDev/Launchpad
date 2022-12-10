class GuiControlParameters extends ParameterBag {
    GetDefaultParameters() {
        return Map(
            "contentWidth", "",
            "defaultHeight", 20,
            "defaults", [],
            "margin", 10,
            "optionPrefixes", ["x", "y", "w", "h", "v"],
            "options", [],
            "position", Map(
                "x", "{{param.margin}}",
                "y", "+{{param.margin}}",
                "w", "",
                "h", ""
            ),
            "requiresHeight", false,
            "requiresWidth", true
        )
    }

    SubRegion(position := "") {
        params := this.Clone()

        if (!position) {
            position := params["position"]
        }

        if (!position["x"]) {
            position["x"] := params["position.x"]
        }

        if (!position["y"]) {
            position["y"] := "+" . params["margin"]
        }

        if (!position["w"] && params["requiresWidth"]) {
            position["w"] := params["position.w"]
        }

        if (!position["h"] && params["requiresHeight"]) {
            position["h"] := params["position.h"]
        }

        return params
    }

    static FromGui(guiObj, params := "") {
        className := this.Prototype.__Class

        if (!params) {
            params := Map()
        }

        if (!params.Has("contentWidth") || !params["contentWidth"]) {
            params["contentWidth"] := guiObj.windowSettings["contentWidth"]
        }

        if (!params.Has("margin") || !params["margin"]) {
            params["margin"] := guiObj.margin
        }

        return %className%(params)
    }

    SplitRegion(columns := 2, height := "") {
        regions := []
        fullWidth := this["position.w"] ? this["position.w"] : this["contentWidth"]

        if (!fullWidth) {
            throw AppException("Cannot split region without a width.")
        }
        marginW := this["margin"] * (columns - 1)
        columnWidth := Floor((fullWidth - marginW) / columns)
        nextX := this["margin"]

        Loop columns {
            columnNumber := %A_Index%
            regionPosition := this._deepClone(this["position"])
            regionPosition["x"] := nextX
            regionPosition["w"] := columnWidth

            if (columnNumber > 1) {
                regionPosition["y"] := "p"
            }

            if (height) {
                regionPosition["h"] := height
            } else {
                regionPosition["h"] := ""
            }

            regions.Push(regionPosition)
            nextX += columnWidth + this["margin"]
        }

        return regions
    }

    /**
     * Takes a map, array, or string of options and turns it into a standardized array
     */
    ParseOptions(options, clone := false) {
        opts := []

        if (HasBase(options, Array.Prototype)) {
            opts := clone ? this.cloner.Clone(options) : options
        } else if (HasBase(options, Map.Prototype)) {
            opts := []

            for key, val in options {
                if (val == true) {
                    opts.Push("+" . key)
                } else if (val == false) {
                    opts.Push("-" . key)
                } else {
                    opts.Push(key . val)
                }
            }
        } else if (options) {
            options := Trim(RegExReplace(options, "\s+", " "))
            opts := StrSplit(options, " ", " `t")
        }

        return opts
    }

    GetOptions() {
        return this.SetDefaultOptions(this["options"])
    }

    SetDefaultOptions(options, defaults := "", applyPositionDefaults := true, fallbackToParamDefaults := true) {
        if (!defaults) {
            defaults := fallbackToParamDefaults ? this["defaults"] : []
        }

        options := this.applyDefaults(options, defaults, true)

        if (applyPositionDefaults) {
            positionDefaults := this["position"].Clone()

            if (this["requiresWidth"] && !positionDefaults["w"] && this["contentWidth"]) {
                positionDefaults["w"] := this["contentWidth"]
            }

            if (this["requiresHeight"] && !positionDefaults["h"] && this["defaultHeight"]) {
                positionDefaults["h"] := this["defaultHeight"]
            }

            options := this.applyDefaults(options, positionDefaults)
        }

        return options
    }

    applyDefaults(options, defaults, clone := false) {
        options := this.ParseOptions(options, clone)
        defaults := this.ParseOptions(defaults)

        for index, option in defaults {
            firstChar := SubStr(option, 1, 1)
            found := false
            invalid := false

            for charIndex, prefix in this["optionPrefixes"] {
                if (firstChar == prefix) {
                    if (prefix == option) {
                        invalid := true
                    } else if (!this.GetOptionIndex(firstChar, options)) {
                        options.Push(option)
                    }

                    found := true
                    break
                }
            }

            if (!invalid && !found && !this.GetOptionIndex(option, options)) {
                options.Push(option)
            }
        }

        return options
    }

    GetOptionIndex(key, options := "") {
        if (!options) {
            options := this["options"]
        }

        result := 0

        for index, option in options {
            firstChar := SubStr(option, 1, 1)
            test := (firstChar == "+" || firstChar == "-") ? SubStr(option, 2) : option
            len := StrLen(key)

            if (SubStr(test, 1, len) == key) {
                result := index
                break
            }
        }

        return result
    }

    GetOptionsString(options := "", defaults := "", applyPositionDefaults := true, fallbackToParamDefaults := true) {
        if (!options) {
            options := fallbackToParamDefaults ? this.GetOptions() : []
        }

        options := this.SetDefaultOptions(options, defaults, applyPositionDefaults, fallbackToParamDefaults)
        str := ""

        for index, option in options {
            if (str) {
                str .= " "
            }

            str .= option
        }

        return str
    }

    GetOption(key, options := "") {
        if (!options) {
            options := this.GetOptions()
        }

        index := this.GetOptionIndex(key, options)
        return index ? options[index] : ""
    }

    RemoveOption(key, options := "") {
        if (!options) {
            options := this["options"]
        }

        index := this.GetOptionIndex(key, options)
        
        if (index) {
            options.RemoveAt(index)
        }

        return options
    }

    SetOption(key, val := "", options := "") {
        if (!options) {
            options := this["options"]
        }

        options := this.RemoveOption(key, options)
        options.Push(key . val)

        return this
    }

    SetOptions(options) {
        for index, option in this.ParseOptions(options) {
            this.SetOption(option)
        }

        return this
    }
}
