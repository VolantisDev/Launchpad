class InstallerManager extends ServiceBase {
    installers := Map()

    SetupInstallers() {
        extraThemes := Map()
        extraDependencyAssets := []

        tmpDir := this.app.tmpDir . "\Installers"
        cache := this.app.Cache.GetCache("file")
        this.SetInstaller("LaunchpadExe", LaunchpadExeInstaller.new(this.app.AppState, cache, tmpDir))
        this.SetInstaller("Launchpad", LaunchpadInstaller.new(this.app.AppState, cache, tmpDir))
        this.SetInstaller("Libraries", LibraryInstaller.new(this.app.AppState, cache, tmpDir))
        this.SetInstaller("Themes", ThemeInstaller.new(this.app.AppState, cache, extraThemes, tmpDir))
        this.SetInstaller("Dependencies", DependencyInstaller.new(this.app.AppState, cache, extraDependencyAssets, tmpDir))
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

    UpdateApp(owner := "UpdateWindow") {
        installerKeys := ["LaunchpadExe"]
        op := UpdateOp.new(this.app, installerKeys, owner)
        return op.Run()
    }

    UpdateDependencies(owner := "MainWindow") {
        installerKeys := ["Dependencies"]
        op := UpdateOp.new(this.app, installerKeys, owner)
        return op.Run()
    }
}
