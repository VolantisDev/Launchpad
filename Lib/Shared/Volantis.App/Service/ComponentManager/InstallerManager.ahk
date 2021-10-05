class InstallerManager extends AppComponentServiceBase {
    _registerEvent := Events.INSTALLERS_REGISTER
    _alterEvent := Events.INSTALLERS_ALTER
    _eventId := "INSTALLERS"

    SetupInstallers() {
    }

    InstallRequirements(owner := "") {
        installers := this.app.Parameter("installers")
        updater := this.app.Parameter("updater")

        installerNames := []
        for key, val in installers {
            if (key != updater) {
                installerNames.Push(key)
            }
        }

        op := InstallOp(this.app, installerNames, owner)
        return op.Run()
    }

    UpdateApp(owner := "") {
        updater := this.app.Parameter("updater")

        if (updater) {
            installerKeys := [updater]
            op := UpdateOp(this.app, installerKeys, owner)
            return op.Run()
        }
    }

    UpdateDependencies(owner := "") {
        installer := this.app.Parameter("dependency_installer")

        if (installer) {
            installerKeys := [installer]
            op := UpdateOp(this.app, installerKeys, owner)
            return op.Run()
        }
    }
}
