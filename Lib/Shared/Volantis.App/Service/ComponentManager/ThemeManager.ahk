class ThemeManager extends ComponentServiceBase {
    _registerEvent := Events.THEMES_REGISTER
    _alterEvent := Events.THEMES_ALTER
    themesDir := ""
    resourcesDir := ""
    defaultTheme := ""
    configObj := ""
    loggerObj := ""
    idGeneratorObj := ""

    __New(eventMgr, configObj, idGeneratorObj, loggerObj, themesDir, resourcesDir, defaultTheme := "", autoLoad := true) {
        InvalidParameterException.CheckTypes("ThemeManager", "themesDir", themesDir, "")
        InvalidParameterException.CheckEmpty("ThemeManager", "themesDir", themesDir)
        this.configObj := configObj
        this.themesDir := themesDir
        this.resourcesDir := resourcesDir
        this.defaultTheme := defaultTheme
        this.loggerObj := loggerObj
        this.idGeneratorObj := idGeneratorObj
        super.__New(eventMgr, "", autoLoad)
    }

    LoadMainTheme() {
        this.LoadTheme(this.GetMainThemeName())
    }

    GetMainThemeName() {
        return (this.configObj.Has("theme_name") && this.configObj["theme_name"] != "") ? this.configObj["theme_name"] : this.defaultTheme
    }

    LoadComponents() {
        this._componentsLoaded := false
        themes := Map()

        Loop Files this.themesDir . "\*", "D" {
            themeName := A_LoopFileName

            if (FileExist(A_LoopFileFullPath . "\" . themeName . ".json")) {
                themes[themeName] := false
            }
        }

        Loop Files this.themesDir . "\*.json" {
            themeName := SubStr(A_LoopFileName, 1, -5) ; Remove .json
            themes[themeName] := false
        }

        this._components := themes
        super.LoadComponents()
    }

    SetThemesDir(themesDir) {
        this.themesDir := themesDir
        this.LoadComponents()
    }

    GetItem(key := "") {
        if (key == "") {
            key := this.GetMainThemeName()
        }

        if (!this.ThemeIsLoaded(key)) {
            return this.LoadTheme(key)
        }

        return super.GetItem(key)
    }

    GetAvailableThemes(locate := false) {
        if (locate) {
            this.LoadComponents()
        }

        themes := []

        for key, val in this._components {
            themes.Push(key)
        }

        return themes
    }

    ThemeIsLoaded(key) {
        return (this._components.Has(key) && this._components[key] != false)
    }

    LoadTheme(key) {
        this._components[key] := JsonTheme(key, this.resourcesDir, this.eventMgr, this.idGeneratorObj, this.loggerObj, true)
        return this._components[key]
    }

    OpenThemeDir() {
        Run(this.themesDir)
    }
}
