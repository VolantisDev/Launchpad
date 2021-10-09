class ThemeManager extends ComponentManagerBase {
    themesDir := ""
    resourcesDir := ""
    defaultTheme := ""
    configObj := ""

    __New(container, eventMgr, notifierObj, configObj, definitionLoader, defaultTheme := "") {
        this.configObj := configObj
        this.defaultTheme := defaultTheme

        eventMgr.Register(ComponentEvents.COMPONENT_DEFINITIONS, "ThemeManagerThemes", ObjBindMethod(this, "DefineServices"))

        super.__New(container, "theme.", eventMgr, notifierObj, ThemeBase, definitionLoader)
    }

    DefineServices(event, extra, eventName, hwnd) {
        services := event.GetDefinitions()

        for themeKey, themeParameters in event.GetParameters() {
            if (!services.Has(themeKey)) {
                services[themeKey] := Map(
                    "factory", ServiceRef("ThemeFactory", "CreateTheme"),
                    "arguments", [themeKey]
                )
            }
        }

        event.SetDefinitions(services)
    }

    GetComponent(themeName := "") {
        if (themeName == "") {
            themeName := this.GetCurrentThemeName()
        }

        return super.GetComponent(themeName)
    }

    GetCurrentThemeName() {
        return this.configObj["theme_name"] ? this.configObj["theme_name"] : this.defaultTheme
    }

    GetThemesDir() {
        return this.configObj["themes_dir"]
    }

    SetThemesDir(themesDir) {
        this.configObj["themes_dir"] := themesDir
        this.configObj.SaveConfig()
        this.LoadComponents()
    }

    GetAvailableThemes() {
        if (!this.loaded) {
            this.LoadComponents()
        }

        themeParams := this.container.GetParameter("theme")

        themes := []

        for key, themeData in themeParams {
            themes.Push(key)
        }

        return themes
    }

    OpenThemeDir() {
        Run(this.GetThemesDir())
    }
}
