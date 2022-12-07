class LauncherCreateFormBase extends FormGuiBase {
    knownGames := ""
    knownPlatforms := ""
    dataSource := ""

    __New(container, themeObj, config) {
        this.dataSource := container.Get("manager.data_source").GetDefaultDataSource()
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
        this.knownGames := this.dataSource.ReadListing("game-keys")
        this.knownPlatforms := this.dataSource.ReadListing("platforms")
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
