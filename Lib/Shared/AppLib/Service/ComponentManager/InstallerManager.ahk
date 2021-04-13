class InstallerManager extends AppComponentServiceBase {
    _registerEvent := "" ;Events.INSTALLERS_REGISTER
    _alterEvent := "" ;Events.INSTALLERS_ALTER
    _eventId := "INSTALLERS"

    SetupInstallers() {
        extraThemes := Map()
        extraDependencyComponents := []

        tmpDir := this.app.tmpDir . "\Installers"
        cache := this.app.Service("CacheManager").GetItem("file")
        this.SetItem("Themes", ThemeInstaller.new(this.app.Version, this.app.State, cache, extraThemes, tmpDir))
    }

    InstallRequirements(owner := "") {
        installerKeys := ["Themes", "Dependencies"]
        op := InstallOp.new(this.app, installerKeys, owner)
        return op.Run()
    }

    UpdateApp(owner := "") {
        installerKeys := ["LaunchpadUpdate"]
        op := UpdateOp.new(this.app, installerKeys, owner)
        return op.Run()
    }

    UpdateDependencies(owner := "") {
        installerKeys := ["Dependencies"]
        op := UpdateOp.new(this.app, installerKeys, owner)
        return op.Run()
    }
}
