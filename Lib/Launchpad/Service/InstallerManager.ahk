class InstallerManager extends ServiceBase {
    installers := Map()

    __New(app, installerDir) {
        super.__New(app)
        this.SetupInstallers()
    }

    SetupInstallers() {
        this.SetInstaller("LaunchpadExe", LaunchpadExeInstaller.new(this.app.AppState, this.app.tmpDir))
        this.SetInstaller("Launchpad", LaunchpadInstaller.new(this.app.AppState, this.app.tmpDir))
        this.SetInstaller("Libraries", LibraryInstaller.new(this.app.AppState, this.app.tmpDir))
        this.SetInstaller("Themes", ThemeInstaller.new(this.app.AppState, this.app.tmpDir))
        this.SetInstaller("Dependencies", DependencyInstaller.new(this.app.AppState, this.app.tmpDir))
    }

    GetInstaller(key) {
        return (this.installers.Has(key)) ? this.installers[key] : ""
    }

    SetInstaller(key, installerObj) {
        this.installers[key] := installerObj
    }

    InstallRequirements(owner := "Mainwindow") {
        installerKeys := ["LaunchpadExe", "Launchpad", "Libraries", "Themes", "Dependencies"]
        op := InstallOp.new(this.app, installerKeys, owner)
        return op.Run()
    }

    UpdateApp() {
        installerKeys := ["LaunchpadExe"]
        op := UpdateUp.new(this.app, installerKeys, owner)
        return op.Run()
    }

    UpdateDependencies() {
        installerKeys := ["Dependencies"]
        op := UpdateUp.new(this.app, installerKeys, owner)
        return op.Run()
    }
}
