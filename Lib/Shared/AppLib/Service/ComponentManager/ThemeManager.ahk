class ThemeManager extends AppComponentServiceBase {
    _registerEvent := "" ;LaunchpadEvents.LAUNCHERS_REGISTER
    _alterEvent := "" ;LaunchpadEvents.LAUNCHERS_ALTER
    themesDir := ""
    resourcesDir := ""
    defaultTheme := ""

    __New(app, themesDir, resourcesDir, defaultTheme := "") {
        InvalidParameterException.CheckTypes("ThemeManager", "themesDir", themesDir, "")
        InvalidParameterException.CheckEmpty("ThemeManager", "themesDir", themesDir)
        this.themesDir := themesDir
        this.resourcesDir := resourcesDir
        this.defaultTheme := defaultTheme
        super.__New(app)
    }

    LoadMainTheme() {
        this.LoadTheme(this.GetMainThemeName())
    }

    GetMainThemeName() {
        return (this.app.Config.HasProp("ThemeName") && this.app.Config.ThemeName != "") ? this.app.Config.ThemeName : this.defaultTheme
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
        this._components[key] := JsonTheme.new(key, this.resourcesDir, this.app.Services, true)
        return this._components[key]
    }

    OpenThemeDir() {
        Run(this.themesDir)
    }
}
