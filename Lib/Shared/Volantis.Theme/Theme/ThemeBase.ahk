class ThemeBase {
    themeId := ""
    iconTheme := "Light"
    name := ""
    themesDir := ""
    resourcesDir := ""
    parentTheme := ""
    defaultTheme := "Lightpad"
    vars := Map()
    colors := Map("background", "FFFFFF", "text", "000000", "textInactive", "959595", "accent", "9466FC", "accentBright", "EEE6FF", "accentBg", "8A57F0", "transColor", "")
    themeAssets := Map("logo", "Resources\Graphics\Logo.png", "icon", "Resources\Graphics\Launchpad.ico", "spinner", "Resources\Graphics\Spinner.gif")
    symbols := Map()
    buttons := Map("height", Map("s", 20, "m", 30, "l", 40, "xl", 80), "fixedWidth", Map("s", 80, "m", 100, "l", 120, "xl", 140))
    labels := Map("height", "auto", "fixedWidth", 75, "font", "normal")
    fonts := Map("normal", "s10 w200", "small", "s11", "large", "s13")
    windowStyles := Map("Child", "E0x40000000L", "Popup", "E0x80000000L", "HScroll", "E0x00100000L", "Tiled", "E0x00000000L")
    windowSettings := Map("default", Map("base", "", "size", Map("width", "auto", "height", "auto"), "position", Map("x", "auto", "y", "auto", "w", "auto", "h", "auto"), "spacing", Map("margin", 10, "windowMargin", "{{margin}}", "buttonSpacing", "{{margin}}"), "saveSize", true, "savePosition", true, "contentWidth", 420, "tabHeight", 350, "listViewHeight", "{{tabHeight}}", "options", Map()), "dialog", Map("base", "default", "saveSize", false, "savePosition", false, "options", Map("Border", true, "Caption", true, "OwnDialogs", false, "Resize", false, "Popup", true)), "form", Map("base", "dialog", "options", Map("Tiled", false)))
    windows := Map()
    themedButtons := Map()
    buttonMap := Map()
    hoveredButton := ""
    loggerObj := ""
    eventMgr := ""
    idGeneratorObj := ""

    __New(name, resourcesDir, eventMgr, idGeneratorObj, loggerObj := "", autoLoad := false) {
        this.name := name
        this.resourcesDir := resourcesDir
        this.themesDir := resourcesDir . "\Themes"
        this.loggerObj := loggerObj
        this.eventMgr := eventMgr
        this.idGeneratorObj := idGeneratorObj
        this.themeId := idGeneratorObj.Generate()
        
        if (autoLoad) {
            this.LoadTheme()
        }

        eventMgr.Register(Events.MOUSE_MOVE, "Theme" . this.themeId, ObjBindMethod(this, "OnMouseMove"))
    }

    __Delete() {
        this.eventMgr.Unregister(Events.MOUSE_MOVE, "Theme" . this.themeId)
        super.__Delete()
    }

    OnMouseMove(wParam, lParam, msg, hwnd) {
        if (hwnd != this.hoveredButton) {
            for btnHwnd, btn in this.themedButtons {
                if (btnHwnd == hwnd) {
                    this.SetHoveredButton(btn["picture"])
                    return
                }
            }

            ; No button is hovered, reset hovered button
            if (this.hoveredButton != "") {
                this.SetNormalButtonState(this.themedButtons[this.hoveredButton]["picture"], true)
                this.hoveredButton := ""
            }
        }
    }

    RGB2BGR(color)
	{
        b := color & 255
        g := (color >> 8) & 255
        r := (color >> 16) & 255

        return format("0x{1:02x}{2:02x}{3:02x}", b, g, r)
	}

    InitializeTheme() {
        iconSrc := this.GetThemeAsset("icon")

        if (iconSrc != "" && FileExist(iconSrc)) {
            TraySetIcon(iconSrc)
        }
    }

    GetIconPath(name) {
        return this.resourcesDir . "\Graphics\Icons\" . this.iconTheme . "\" . name . ".ico"
    }

    GetColor(id) {
        return this.colors.Has(id) ? this.colors[id] : "000000"
    }

    GetThemeAsset(id) {
        asset := (this.themeAssets.Has(id)) ? this.themeAssets[id] : ""

        if (asset and this.resourcesDir and !InStr(asset, ":")) {
            asset := this.resourcesDir . "\" . asset
        }

        return asset
    }

    GetSymbol(id, config) {
        symbolClass := (this.symbols.Has(id)) ? this.symbols[id] : ""

        symbol := ""

        if (symbolClass) {
            symbol := %symbolClass%(config)
        }

        return symbol
    }

    GetButtonSize(id, fixedWidth := false) {
        buttonSize := Map("h", "auto", "w", "auto")

        if (this.buttons["height"].Has(id)) {
            buttonSize["h"] := this.buttons["height"][id]
        }

        if (fixedWidth && this.buttons["fixedWidth"].Has(id)) {
            buttonSize["w"] := this.buttons["fixedWidth"][id]
        }

        return buttonSize
    }

    GetFont(id) {
        return (this.fonts.Has(id)) ? this.fonts[id] : this.fonts["normal"]
    }

    GetWindowSettings(guiId) {
        windowConfig := (this.windows.Has(guiId)) ? this.windows[guiId] : Map("settings", "default")

        if (windowConfig.Has("settings") && windowConfig["settings"] != "") {
            windowConfig := this.MergeProperty(windowConfig, this.LoadWindowSettings(windowConfig["settings"]))
        }

        return windowConfig
    }

    LoadWindowSettings(settingsKey) {
        windowSettings := ""

        if (this.windowSettings.Has(settingsKey)) {
            windowSettings := this.windowSettings[settingsKey]
        } else {
            windowSettings := this.windowSettings["default"]
        }

        if (windowSettings.Has("base") && windowSettings["base"] != "") {
            parentSettings := this.GetWindowSettings(windowSettings["base"])
            windowSettings := this.MergeProperty(windowSettings, parentSettings, false)
        }

        return this.DereferenceEnumerable(windowSettings)
    }

    GetWindowOptionsString(guiId, extraOptions := "") {
        windowOptions := ""
        windowSettings := this.GetWindowSettings(guiId)

        opts := (windowSettings.Has("options") && windowSettings["options"] != "") ? windowSettings["options"].Clone() : Map()

        if (extraOptions) {
            for key, val in extraOptions {
                opts[key] := val
            }
        }

        for key, val in opts {
            if (val != "") {
                if this.windowStyles.Has(key) {
                    key := this.DereferenceValue(this.windowStyles[key], this.windowStyles)
                }

                if (windowOptions != "") {
                    windowOptions .= " "
                }

                if (val) {
                    windowOptions .= "+" . key
                } else if (val == false) {
                    windowOptions .= "-" . key
                }

                if (Type(val) == "String" && val != "") {
                    windowOptions .= val
                }
            }
        }

        return windowOptions
    }

    DereferenceValues(themeMap := "") {
        if (themeMap == "") {
            this.name := this.DereferenceValue(this.name, this.vars)
            this.vars := this.DereferenceEnumerable(this.vars)
            this.colors := this.DereferenceEnumerable(this.colors)
            this.themeAssets := this.DereferenceEnumerable(this.themeAssets)
            this.buttons := this.DereferenceEnumerable(this.buttons)
            this.labels := this.DereferenceEnumerable(this.labels)
            this.fonts := this.DereferenceEnumerable(this.fonts)
            this.windowStyles := this.DereferenceEnumerable(this.windowStyles)
            this.windowSettings := this.DereferenceEnumerable(this.windowSettings)
            this.windows := this.DereferenceEnumerable(this.windows)
        } else {
            return this.DereferenceEnumerable(themeMap)
        }
    }

    DereferenceEnumerable(enum) {
        for key, val in enum {
            if (Type(val) == "Map" || Type(val) == "Array") {
                enum[key] := this.DereferenceEnumerable(val)
            } else {
                enum[key] := this.DereferenceValue(val, enum)
            }
        }

        return enum
    }

    DereferenceValue(value, valueMap, endRecursion := false) {
        for (key, val in valueMap) {
            if (value == "{{" . key . "}}") {
                value := StrReplace(value, "{{" . key . "}}", this.DereferenceValue(val, valueMap))
            }
        }

        return endRecursion ? value : this.DereferenceValue(value, this.vars, true)
    }

    ExpandPaths(themeMap := "") {
        if (Type(themeMap) == "Map" && themeMap.Count == 0) {
            themeMap := ""
        }

        if (themeMap == "" || themeMap.Has("themeAssets")) {
            themeAssets := themeMap != "" ? themeMap["themeAssets"] : this.themeAssets
        }

        themeName := themeMap != "" ? themeMap["name"] : this.name
        parentTheme := themeMap != "" ? themeMap["parentTheme"] : this.parentTheme
        
        for key, val in themeAssets {
            themeAssets[key] := this.ExpandPath(val, themeName, parentTheme)
        }

        return themeMap
    }

    ExpandPath(value, themeName := "", parentTheme := "") {
        if (value != "") {
            SplitPath(value,,,,, &driveLetter)

            if (driveLetter == "") {
                themePath := this.themesDir . "\" . this.name . "\" . value
                parentThemePath := parentTheme ? this.themesDir . "\" . parentTheme . "\" . value : ""
                defaultThemePath := this.themesDir . "\" . this.defaultTheme . "\" . value

                if (FileExist(themePath)) {
                    value := themePath
                } else if (FileExist(parentThemePath)) {
                    value := parentThemePath
                } else if (FileExist(defaultThemePath)) {
                    value := defaultThemePath
                }
            }
        }

        return value
    }

    LoadValuesIntoTheme(themeMap) {
        InvalidParameterException.CheckTypes("ThemeBase", "themeMap", themeMap, "Map")

        if (themeMap.Count > 0) {
            if (themeMap.Has("parentTheme") && themeMap["parentTheme"] != "") {
                parentMap := this.GetThemeMap(themeMap["parentTheme"])

                if (Type(parentMap) == "Map") {
                    this.LoadValuesIntoTheme(parentMap)
                }
            }

            themeMap := this.DereferenceValues(themeMap)
            themeMap := this.ExpandPaths(themeMap)

            for key, val in themeMap {
                if (key == "name" or key == "parentTheme" or key == "themesDir") {
                    continue
                }

                if (this.HasProp(key)) {
                    this.%key% := this.MergeProperty(this.%key%, val, true)
                }
            }
        }
    }

    MergeProperty(existingValue, newValue, overwriteMapKeys := false) {
        if (Type(existingValue) == "Map" && Type(newValue) == "Map") {
            newValue := this.MergeMap(existingValue.Clone(), newValue, overwriteMapKeys)
        } else if (Type(existingValue) == "Array" && Type(newValue) == "Array") {
            newValue := this.MergeArray(existingValue.Clone(), newValue, overwriteMapKeys)
        }

        return newValue
    }

    MergeMap(existingMap, newMap, overwriteKeys := false) {
        for key, val in newMap {
            if (overwriteKeys or !existingMap.Has(key)) {
                existingMap[key] := existingMap.Has(key) ? this.MergeProperty(existingMap[key], val, overwriteKeys) : val
            }
        }

        return existingMap
    }

    MergeArray(existingArray, newArray, overwriteMapKeys := false) {
        for index, val in newArray {
            valueExists := false
            existingType := ""

            for existingIndex, existingVal in existingArray {
                if (existingVal == val) {
                    valueExists := existingIndex
                    existingType := Type(existingVal)
                    break
                }
            }

            if (valueExists) {
                existingArray[valueExists] := this.MergeProperty(existingArray[valueExists], val, overwriteMapKeys)
            } else {
                existingArray.Push(val)
            }
        }

        return existingArray
    }

    LoadTheme(themeName := "") {
        if (themeName == "") {
            themeName := this.name
        }

        themeMap := this.GetThemeMap(themeName)

        if (Type(themeMap) != "Map") {
            InvalidParameterException("The provided theme name cannot be resolved to a valid theme.")
        }

        this.name := themeMap.Has("name") ? themeMap["name"] : themeName
        this.parentTheme := themeMap.Has("parentTheme") ? themeMap["parentTheme"] : ""
        this.LoadValuesIntoTheme(themeMap)
        this.DereferenceValues()
        this.ExpandPaths()
        this.InitializeTheme()
        return this
    }

    GetThemeMap(themeName) {
        throw MethodNotImplementedException("ThemeBase", "GetThemeMap")
    }

    DrawButton(picObj, content, style := "normal", drawConfig := "") {
        picObj.IsPrimary := (style == "primary")

        states := Map()
        buttonStyle := this.GetButtonStyle(style)

        try {
            enabledStyle := buttonStyle["enabled"]
            disabledStyle := buttonStyle.Has("disabled") ? buttonStyle["disabled"] : buttonStyle["enabled"]
            hoveredStyle := buttonStyle.Has("hovered") ? buttonStyle["hovered"] : buttonStyle["enabled"]

            enabledShape := enabledStyle.Has("shape") ? enabledStyle["shape"] : "ButtonShape"
            states["enabled"] := %enabledShape%(this, content, enabledStyle, drawConfig)
            
            disabledShape := disabledStyle.Has("shape") ? disabledStyle["shape"] : "ButtonShape"
            states["disabled"] := %disabledShape%(this, content, disabledStyle, drawConfig)
            
            hoveredShape := hoveredStyle.Has("shape") ? hoveredStyle["shape"] : "ButtonShape"
            states["hovered"] := %hoveredShape%(this, content, hoveredStyle, drawConfig)

            states["enabled"].DrawOn(picObj)

            

            this.themedButtons[picObj.Hwnd] := Map("picture", picObj, "content", content, "states", states)
        } catch as ex {
            throw ex
        }

        return picObj
    }

    DereferenceColor(color) {
        return this.DereferenceValue(color, this.colors)
    }

    GetButtonStyle(style) {
        result := (style != "default") ? this.GetButtonStyle("default") : Map()

        if (this.buttons.Has("styles") and this.buttons["styles"].Has(style)) {
            result := this.MergeProperty(result, this.buttons["styles"][style], true)
        }

        for idx, state in ["enabled", "disabled", "hovered"] {
            if (result.Has(state)) {
                result[state] := result[state].Clone()
            } else {
                result[state] := Map()
            }

            for key, val in result[state] {
                if (SubStr(val, 1, 2) == "{{") {
                    result[state][key] := this.DereferenceColor(val)
                }
            }
        }

        return result
    }

    SetNormalButtonState(btn, ignoreErrors := false) {
        try {
            btn := this.themedButtons[this.hoveredButton]["states"]["enabled"].DrawOn(btn)
        } catch as ex {
            if (!ignoreErrors) {
                if (this.loggerObj) {
                    this.loggerObj.Error("Failed to change button hover state: " . ex.Message)
                }
            }
        }
        
        return btn
    }

    SetHoveredButton(btn, ignoreErrors := false) {
        if (this.hoveredButton == btn.Hwnd) {
            return
        }

        if (this.hoveredButton != "") {
            this.SetNormalButtonState(this.themedButtons[this.hoveredButton]["picture"])
            this.hoveredButton := ""
        }

        try {
            btn := this.themedButtons[btn.Hwnd]["states"]["hovered"].DrawOn(btn)
        } catch as ex {
            if (!ignoreErrors) {
                if (this.loggerObj) {
                    this.loggerObj.Error("Failed to change button hover state: " . ex.Message)
                }
            }
        }

        this.hoveredButton := btn.Hwnd
        return btn
    }

    SetFrameShadow(hwnd) {
        isEnabled := 0
        DllCall("dwmapi\DwmIsCompositionEnabled", "IntP", isEnabled)

        if (isEnabled) {
            margins := Buffer(16)
            NumPut("UInt", 1, margins, 0)
            NumPut("UInt", 1, margins, 4)
            NumPut("UInt", 1, margins, 8)
            NumPut("UInt", 1, margins, 12)
            val := 2
            DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "UInt", 2, "Int*", &val, "UInt", 4)
            DllCall("dwmapi\DwmExtendFrameIntoClientArea", "Ptr", hwnd, "Ptr", margins)
        }
    }

    CalculateTextWidth(text) {
        graphics := ""
        font := "Arial"
        size := 12
        options := "Regular"
        style := 0
        styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
        formatStyle := 0x4000 | 0x1000

        for eachStyle, valStyle in StrSplit(styles, "|")
        {
            if RegExMatch(options, "\b" valStyle) {
                style |= (valStyle != "StrikeOut") ? (A_Index-1) : 8
            }  
        }

        hdc := GetDC()
        graphics := Gdip_GraphicsFromHDC(hdc)
        hFamily := Gdip_FontFamilyCreate(font)
        hFont := Gdip_FontCreate(hFamily, size, style)
        hFormat := Gdip_StringFormatCreate(formatStyle)
        CreateRectF(&RC, 0, 0, 0, 0)
        returnRc := Gdip_MeasureString(graphics, text, hFont, hFormat, &RC)
        returnRc := StrSplit(returnRc, "|")
        return returnRc[3]
    }
}
