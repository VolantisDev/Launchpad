class ChocoDeployer extends BuildDeployerBase {
    Deploy(deployInfo) {
        distDir := this.app.Config.DistDir
        RunWait("choco push", distDir)
        return true
    }
}
