class LauncherCreateFormBase extends FormGuiBase {
    knownGames := ""
    knownPlatforms := ""
    dataSource := ""

    __New(app, themeObj, windowKey, title, owner := "", parent := "") {
        this.dataSource := app.DataSources.GetItem()
        super.__New(app, themeObj, windowKey, title, this.GetTextDefinition(), owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        return "Use this form to create a new Launchpad launcher."
    }

    GetButtonsDefinition() {
        return "*&Save|&Cancel"
    }

    Create() {
        super.Create()
        this.knownGames := this.dataSource.ReadListing("game-keys")
        this.knownPlatforms := this.dataSource.ReadListing("platforms")
    }

    ProcessResult(result, submittedData := "") {
        entity := ""

        if (result == "Save") {
            entity := LauncherEntity.new(this.app, this.GetLauncherKey(), this.GetLauncherConfig())
        }

        return entity
    }

    GetLauncherKey() {
        throw MethodNotImplementedException.new("LauncherCreateFormBase", "GetLauncherKey")
    }

    GetLauncherConfig() {
        throw MethodNotImplementedException.new("LauncherCreateFormBase", "GetLauncherConfig")
    }
}
