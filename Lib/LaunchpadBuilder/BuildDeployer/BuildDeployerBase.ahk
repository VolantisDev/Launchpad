class BuildDeployerBase {
    app := ""

    __New(app) {
        this.app := app
    }

    Deploy(deployInfo) {
        throw MethodNotImplementedException.new("BuildDeployerBase", "Deploy")
    }
}
