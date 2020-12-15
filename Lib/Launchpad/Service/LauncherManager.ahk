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
        if (launcherFile == "") {
            launcherFile := this.app.Config.LauncherFile
        }

        if (!IsObject(launcherFile)) {
            launcherFile := LauncherConfig.new(this.app, launcherFile, false)
        }

        this.launchersConfigObj := launcherFile

        operation := LoadLaunchersOp.new(this.app, launcherFile)
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
}
