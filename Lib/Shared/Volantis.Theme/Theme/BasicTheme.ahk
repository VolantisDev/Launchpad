class BasicTheme extends ThemeBase {
    container := ""
    
    __new(container, name, resourcesDir, eventMgr, idGeneratorObj, loggerObj := "") {
        this.container := container
        super.__New(name, resourcesDir, eventMgr, idGeneratorObj, loggerObj, true)
    }

    GetThemeMap(themeName) {
        return this.container.GetParameter("theme." . themeName)
    }
}
