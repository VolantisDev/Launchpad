class BuildDeployerBase {
    app := ""

    __New(app) {
        this.app := app
    }

    Deploy(deployInfo) {
        throw MethodNotImplementedException("BuildDeployerBase", "Deploy")
    }
}
