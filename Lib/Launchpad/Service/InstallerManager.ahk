class InstallerManager extends ServiceBase {
    installers := Map()

    SetupInstallers() {
        extraThemes := Map()
        extraDependencyAssets := []
        this.SetInstaller("LaunchpadExe", LaunchpadExeInstaller.new(this.app.AppState, this.app.tmpDir))
        this.SetInstaller("Launchpad", LaunchpadInstaller.new(this.app.AppState, this.app.tmpDir))
        this.SetInstaller("Libraries", LibraryInstaller.new(this.app.AppState, this.app.tmpDir))
        this.SetInstaller("Themes", ThemeInstaller.new(this.app.AppState, extraThemes, this.app.tmpDir))
        this.SetInstaller("Dependencies", DependencyInstaller.new(this.app.AppState, extraDependencyAssets, this.app.tmpDir))
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
        op := UpdateOp.new(this.app, installerKeys, owner)
        return op.Run()
    }

    UpdateDependencies() {
        installerKeys := ["Dependencies"]
        op := UpdateOp.new(this.app, installerKeys, owner)
        return op.Run()
    }
}
