class LauncherManager extends AppComponentServiceBase {
    _registerEvent := LaunchpadEvents.LAUNCHERS_REGISTER
    _alterEvent := LaunchpadEvents.LAUNCHERS_ALTER
    launcherConfigObj := ""

    Launchers[] {
        get => this._components
        set => this._components := value
    }

    __New(app, launcherFile := "") {
        this.launcherConfigObj := LauncherConfig.new(app, launcherFile, false)
        super.__New(app, "", false)
    }

    LoadComponents(launcherFile := "") {
        this._componentsLoaded := false

        if (launcherFile != "") {
            this.launcherConfigObj.ConfigPath := launcherFile
        }

        if (this.launcherConfigObj.ConfigPath == "") {
            this.launcherConfigObj.ConfigPath := this.app.Config.LauncherFile
        }

        operation := LoadLaunchersOp.new(this.app, this.launcherConfigObj)
        success := operation.Run()
        this._components := operation.GetResults()
        super.LoadCopmonents() ; Allow launchers to be added to or altered

        return success
    }

    GetLauncherConfig() {
        return this.launcherConfigObj
    }

    CountLaunchers() {
        return this.Launchers.Count
    }

    SaveModifiedLaunchers() {
        this.launcherConfigObj.SaveConfig()
    }

    RemoveLauncher(key) {
        if (this.Launchers.Has(key)) {
            this.Launchers.Delete(key)
            this.launcherConfigObj.Games.Delete(key)
        }
    }

    AddLauncher(key, launcher) {
        this.Launchers[key] := launcher
        this.launcherConfigObj.Games[key] := launcher.UnmergedConfig
        ; @todo should this use configObj instead of UnmergedConfig (which is a clone)?
    }
}
