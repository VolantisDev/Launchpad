class LauncherManager extends AppComponentServiceBase {
    launcherConfigObj := ""
    launchersLoaded := false

    Launchers[] {
        get => this._components
        set => this._components := value
    }

    __New(app, launcherFile := "") {
        this.launcherConfigObj := LauncherConfig.new(app, launcherFile, false)
        super.__New(app)
    }

    LoadLaunchers(launcherFile := "") {
        if (launcherFile != "") {
            this.launcherConfigObj.ConfigPath := launcherFile
        }

        if (this.launcherConfigObj.ConfigPath == "") {
            this.launcherConfigObj.ConfigPath := this.app.Config.LauncherFile
        }

        operation := LoadLaunchersOp.new(this.app, this.launcherConfigObj)
        success := operation.Run()
        this._components := operation.GetResults()
        this.launchersLoaded := true
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
    }
}
