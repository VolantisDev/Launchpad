class LauncherCreateFormBase extends FormGuiBase {
    knownGames := ""
    knownPlatforms := ""
    launcherMgr := ""
    platformMgr := ""

    __New(container, themeObj, config) {
        this.launcherMgr := container.Get("entity_manager.launcher")
        this.platformMgr := container.Get("entity_manager.platform")
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["text"] := "Use this form to create a new Launchpad launcher."
        defaults["buttons"] := "*&Save|&Cancel"
        return defaults
    }

    Create() {
        super.Create()
        this.knownGames := this.launcherMgr.ListEntities(false, true)
        this.knownPlatforms := this.platformMgr.ListEntities(false, true)
    }

    ProcessResult(result, submittedData := "") {
        entity := ""

        if (result == "Save") {
            entity := LauncherEntity(this.app, this.GetLauncherKey(), this.GetLauncherConfig())
        }

        return entity
    }

    GetLauncherKey() {
        throw MethodNotImplementedException("LauncherCreateFormBase", "GetLauncherKey")
    }

    GetLauncherConfig() {
        throw MethodNotImplementedException("LauncherCreateFormBase", "GetLauncherConfig")
    }
}
