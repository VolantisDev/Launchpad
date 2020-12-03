class ThemeBase {
    name := ""
    baseDir := ""

    vars := Map()
    colors := Map("background", "FFFFFF", "text", "000000", "textLight", "959595", "accent", "9466FC", "accentLight", "EEE6FF", "accentDark", "8A57F0", "transColor", "")
    graphics := Map("logo", "Graphics\Logo.png", "icon", "Graphics\Launchpad.ico")
    buttonSizes := Map("smallFixed", Map("h", 20, "w", 80), "small", Map("h", 20, "w", "auto"), "normal", Map("h", 30, "w", "auto"), "big", Map("h", 40, "w", "auto"), "huge", Map("h", 80, "w", "auto"))
    spacing := Map("margin", 10, "windowMargin", 10, "buttonMargin", 10)
    fonts := Map("normal", "s11", "small", "s10 w200", "large", "s13")
    defaultWindowOptions := ""
    dialogWindowOptions := ""
    defaultWindowSettings := Map("windowOptions", "", "saveSize", true, "savePosition", true, "contentWidth", 420, "tabHeight", 350, "listViewHeight", 350, "x", "auto", "y", "auto", "w", "auto", "h", "auto")
    windowOverrides := Map()
    fixedLabelW := 75

    __New(name, baseDir, autoLoad := false) {
        this.name := name
        this.baseDir := baseDir
        
        if (autoLoad) {
            this.LoadTheme()
        }
    }

    InitializeTheme() {
        iconSrc := this.GetGraphic("icon")

        if (iconSrc != "" and FileExist(iconSrc)) {
            TraySetIcon(iconSrc)
        }
    }

    GetColor(id) {
        colorHex := "000000"

        if (this.colors.Has(id)) {
            colorHex := this.DereferenceValue(this.colors[id], this.colors) 
        }

        return colorHex
    }

    GetGraphic(id) {
        graphic := (this.graphics.Has(id)) ? this.DereferenceValue(this.graphics[id], this.graphics) : ""

        if (graphic != "") {
            SplitPath(graphic,,,,,driveLetter)

            if (driveLetter == "") {
                themeLocalPath := this.baseDir . "\Themes\" . this.name . "\" . graphic
                appLocalPath := this.baseDir . "\" . graphic

                if (FileExist(themeLocalPath)) {
                    graphic := themeLocalPath
                } else if (FileExist(appLocalPath)) {
                    graphic := appLocalPath
                }
            }
        }

        return graphic
    }

    GetButtonSize(id) {
        buttonSize := Map("h", "auto", "w", "auto")

        if (this.buttonSizes.Has(id)) {
            configuredButtonSize := this.DereferenceValue(this.buttonSizes[id], this.buttonSizes)

            if (Type(configuredButtonSize) == "Map") {
                for key, value in configuredButtonSize {
                    buttonSize[key] := value
                }
            }
        }

        return buttonSize
    }

    GetSpacing(id := "margin") {
        spacing := ""

        if (this.spacing.Has(id)) {
            spacing := this.DereferenceValue(this.spacing[id], this.spacing)
        }

        if (!IsNumber(spacing)) {
            spacing := 10
        }

        return spacing
    }

    GetFont(id) {
        fontSize := this.fonts["normal"]

        if (this.fonts.Has(id)) {
            fontSize := this.fonts[id]
        }

        return this.DereferenceValue(fontSize, this.fonts)
    }

    GetWindowOptions(windowKey := "", isDialog := false) {
        windowOptions := ""
        
        if (this.windowOverrides.Has(windowKey) and this.windowOverrides[windowKey].Has("windowOptions")) {
            windowOptions := this.windowOverrides[windowKey]["windowOptions"]
        } else {
            windowOptions := isDialog ? this.dialogWindowOptions : this.defaultWindowOptions
        }

        return windowOptions
    }

    GetWindowSettings(windowKey) {
        windowSettings := this.defaultWindowSettings

        if (this.windowOverrides.Has(windowKey)) {
            for key, val in this.windowOverrides[windowKey] {
                windowSettings[key] := val
            }
        }

        for key, val in windowSettings {
            windowSettings[key] := this.DereferenceValue(windowSettings[key], windowSettings)
        }

        return windowSettings
    }

    DereferenceValue(value, valueMap, endRecursion := false) {
        for (key, val in valueMap) {
            if (value == "{{" . key . "}}") {
                value := StrReplace(value, "{{" . key . "}}", this.DereferenceValue(val, valueMap))
            }
        }

        return endRecursion ? value : this.DereferenceValue(value, this.vars, true)
    }

    LoadValuesIntoTheme(themeMap) {
        InvalidParameterException.CheckTypes("ThemeBase", "themeMap", themeMap, "Map")

        if (themeMap.Has("parentTheme") and themeMap["parentTheme"] != "") {
            parentMap := this.GetThemeMap(themeMap["parentTheme"])

            if (Type(parentMap) == "Map") {
                this.LoadValuesIntoTheme(parentMap)
            }
        }

        for key, val in themeMap {
            if (key == "name" or key == "parentTheme" or key == "baseDir") {
                continue
            }

            if (this.HasProp(key)) {
                this.%key% := this.MergeProperty(this.%key%, val, true)
            }
        }
    }

    MergeProperty(existingValue, newValue, overwriteMapKeys := false) {
        if (Type(existingValue) == "Map" and Type(newValue) == "Map") {
            newValue := this.MergeMap(existingValue, newValue, overwriteMapKeys)
        } else if (Type(existingValue) == "Array" and Type(newValue) == "Array") {
            newValue := this.MergeArray(existingValue, newValue, overwriteMapKeys)
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
            InvalidParameterException.new("The provided theme name cannot be resolved to a valid theme.")
        }

        this.name := themeMap.Has("name") ? themeMap["name"] : themeName

        this.LoadValuesIntoTheme(themeMap)

        this.InitializeTheme()

        return this
    }

    GetThemeMap(themeName) {
        throw MethodNotImplementedException.new("ThemeBase", "GetThemeMap")
    }
}
