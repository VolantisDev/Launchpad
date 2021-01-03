class ThemeManager extends AppComponentServiceBase {
    themesDir := ""
    defaultTheme := "Steampad"
    eventManager := ""
    idGenerator := ""

    __New(app, themesDir, eventManager, idGenerator) {
        InvalidParameterException.CheckTypes("ThemeManager", "themesDir", themesDir, "", "eventManager", eventManager, "EventManager")
        InvalidParameterException.CheckEmpty("ThemeManager", "themesDir", themesDir, "eventManager", eventManager)
        this.themesDir := themesDir
        this.eventManager := eventManager
        this.idGenerator := idGenerator
        super.__New(app)
        this.LocateThemes()
    }

    LoadMainTheme() {
        this.LoadTheme(this.GetMainThemeName())
    }

    GetMainThemeName() {
        return (this.app.Config.ThemeName != "") ? this.app.Config.ThemeName : this.defaultTheme
    }

    LocateThemes() {
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
    }

    SetThemesDir(themesDir) {
        this.themesDir := themesDir
        this.LocateThemes()
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
            this.LocateThemes()
        }

        themes := []

        for key, val in this._components {
            themes.Push(key)
        }

        return themes
    }

    ThemeIsLoaded(key) {
        return (this._components.Has(key) and this._components[key] != false)
    }

    LoadTheme(key) {
        this._components[key] := JsonTheme.new(key, this.themesDir, this.eventManager, this.idGenerator, true)
        return this._components[key]
    }

    OpenThemeDir() {
        Run(this.themesDir)
    }
}
