class ThemeFactory {
    container := ""
    resourcesDir := ""
    eventMgr := ""
    idGeneratorObj := ""
    loggerObj := ""

    __New(container, resourcesDir, eventMgr, idGeneratorObj, loggerObj) {
        this.container := container
        this.resourcesDir := resourcesDir
        this.eventMgr := eventMgr
        this.idGeneratorObj := idGeneratorObj
        this.loggerObj := loggerObj
    }

    CreateTheme(key) {
        if (Type(key) != "String") {
            throw AppException("Invalid theme key: " . Debugger().ToString(key))
        }

        return BasicTheme(
            this.container,
            key,
            this.resourcesDir,
            this.eventMgr,
            this.idGeneratorObj,
            this.loggerObj
        )
    }
}