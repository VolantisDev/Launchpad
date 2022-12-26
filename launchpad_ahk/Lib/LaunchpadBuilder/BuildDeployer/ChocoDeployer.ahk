class ChocoDeployer extends BuildDeployerBase {
    Deploy(deployInfo) {
        distDir := this.app.Config["dist_dir"]
        RunWait("choco push", distDir)
        return true
    }
}
