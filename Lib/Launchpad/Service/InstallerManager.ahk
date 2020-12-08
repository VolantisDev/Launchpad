class InstallerManager extends ServiceBase {
    installers := Map()

    SetupInstallers() {
        extraThemes := Map()
        extraDependencyComponents := []

        tmpDir := this.app.tmpDir . "\Installers"
        cache := this.app.Cache.GetCache("file")
        this.SetInstaller("LaunchpadUpdate", LaunchpadUpdate.new(this.app.AppState, cache, tmpDir))
        this.SetInstaller("Themes", ThemeInstaller.new(this.app.AppState, cache, extraThemes, tmpDir))
        this.SetInstaller("Dependencies", DependencyInstaller.new(this.app.AppState, cache, extraDependencyComponents, tmpDir))
    }

    GetInstaller(key) {
        return (this.installers.Has(key)) ? this.installers[key] : ""
    }

    SetInstaller(key, installerObj) {
        this.installers[key] := installerObj
    }

    InstallRequirements(owner := "Mainwindow") {
        installerKeys := ["Themes", "Dependencies"]
        op := InstallOp.new(this.app, installerKeys, owner)
        return op.Run()
    }

    UpdateApp(owner := "UpdateWindow") {
        installerKeys := ["LaunchpadUpdate"]
        op := UpdateOp.new(this.app, installerKeys, owner)
        return op.Run()
    }

    UpdateDependencies(owner := "MainWindow") {
        installerKeys := ["Dependencies"]
        op := UpdateOp.new(this.app, installerKeys, owner)
        return op.Run()
    }
}
