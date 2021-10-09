class InstallerManager extends AppComponentManagerBase {
    __New(container, eventMgr, notifierObj) {
        super.__New(container, eventMgr, notifierObj, "installer.", InstallerBase)
    }

    RunInstallers(installerType := "", owner := "") {
        installers := []

        ; TODO: Move installerType to the service definition to prevent having to actually load all installers
        for (name, installer in this.All()) {
            if (!installerType || installer.installerType == installerType) {
                installers.Push(name)
            }
        }

        op := InstallOp(this.container.GetApp(), installers, owner)
        return op.Run()
    }
}
