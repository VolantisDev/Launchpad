class InstallerManager extends AppComponentServiceBase {
    SetupInstallers() {
        extraThemes := Map()
        extraDependencyComponents := []

        tmpDir := this.app.tmpDir . "\Installers"
        cache := this.app.Cache.GetItem("file")
        this.SetItem("LaunchpadUpdate", LaunchpadUpdate.new(this.app.AppState, cache, tmpDir))
        this.SetItem("Themes", ThemeInstaller.new(this.app.AppState, cache, extraThemes, tmpDir))
        this.SetItem("Dependencies", DependencyInstaller.new(this.app.AppState, cache, extraDependencyComponents, tmpDir))
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
