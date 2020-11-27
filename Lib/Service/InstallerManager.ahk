class InstallerManager extends ServiceBase {
    installers := Map()

    __New(app, installerDir) {
        super.__New(app)

        this.SetupInstallers()
    }

    SetupInstallers() {
        
    }

    GetInstaller(key) {
        return (this.installers.Has(key)) ? this.installers[key] : ""
    }

    SetInstaller(key, installerObj) {
        this.installers[key] := installerObj
    }
}
