class InstallerManager extends AppComponentServiceBase {
    _registerEvent := "" ;Events.INSTALLERS_REGISTER
    _alterEvent := "" ;Events.INSTALLERS_ALTER
    _eventId := "INSTALLERS"

    SetupInstallers() {
        extraThemes := Map()
        extraDependencyComponents := []

        tmpDir := this.app.tmpDir . "\Installers"
        this.SetItem("Themes", ThemeInstaller(this.app.Version, this.app.State, this.app.Service("CacheManager"), "file", extraThemes, tmpDir))
    }

    InstallRequirements(owner := "") {
        installerKeys := ["Themes", "Dependencies"]
        op := InstallOp(this.app, installerKeys, owner)
        return op.Run()
    }

    UpdateApp(owner := "") {
        installerKeys := ["LaunchpadUpdate"]
        op := UpdateOp(this.app, installerKeys, owner)
        return op.Run()
    }

    UpdateDependencies(owner := "") {
        installerKeys := ["Dependencies"]
        op := UpdateOp(this.app, installerKeys, owner)
        return op.Run()
    }
}
