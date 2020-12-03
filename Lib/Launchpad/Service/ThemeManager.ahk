class ThemeManager extends ServiceBase {
    themesDir := ""
    defaultTheme := "Lightpad"
    themes := Map()

    __New(app, themesDir) {
        InvalidParameterException.CheckTypes("ThemeManager", "themesDir", themesDir, "")
        InvalidParameterException.CheckEmpty("ThemeManager", "themesDir", themesDir)
        this.themesDir := themesDir
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

        this.themes := themes
    }

    SetThemesDir(themesDir) {
        this.themesDir := themesDir
        this.LocateThemes()
    }

    GetTheme(key := "") {
        if (key == "") {
            key := this.GetMainThemeName()
        }

        themeObj := ""

        if (this.themes.Has(key)) {
            if (!this.ThemeIsLoaded(key)) {
                themeObj := this.LoadTheme(key)
            } else {
                themeObj := this.themes[key]
            }
        }

        return themeObj
    }

    GetAvailableThemes(locate := false) {
        if (locate) {
            this.LocateThemes()
        }

        themes := []

        for key, val in this.themes {
            themes.Push(key)
        }

        return themes
    }

    ThemeIsLoaded(key) {
        return (this.themes.Has(key) and this.themes[key] != false)
    }

    LoadTheme(key) {
        this.themes[key] := JsonTheme.new(key, this.themesDir, true)
        return this.themes[key]
    }

    OpenThemeDir() {
        Run(this.themesDir)
    }
}
