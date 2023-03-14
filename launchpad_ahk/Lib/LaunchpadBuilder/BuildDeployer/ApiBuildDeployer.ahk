class ApiBuildDeployer extends BuildDeployerBase {
    Deploy(deployInfo) {
        apiUrl := "https://api.launchpad.games/v1/release-info"
        
        this.app["manager.gui"].Dialog(Map(
            "title", "Not Yet Available",
            "text", "Release info pushing is not yet available. Please update release info manually."
        ))

        Run("https://console.firebase.google.com/u/0/project/launchpad-306703/firestore/data~2Frelease-info~2Fstable")
    }
}
