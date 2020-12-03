class LaunchpadInstaller extends InstallerBase {
    name := "Launchpad Installer"
    parentComponent := "LaunchpadExe"
    version := "latest"

    __New(appState, cache, tmpDir := "") {
        assets := []

        asset := GitHubReleaseInstallerAsset.new("VolantisDev/Launchpad", "LaunchpadUpdater.exe", true, "", appState, "LaunchpadUpdater", cache, this.appName, true, tmpDir, true)
        asset.version := this.version
        assets.Push(asset)

        asset := GitHubReleaseInstallerAsset.new("VolantisDev/Launchpad", "LaunchpadGraphics.zip", true, "Graphics", appState, "LaunchpadGraphics", cache, this.appName, true, tmpDir, true)
        asset.version := this.version
        assets.Push(asset)

        super.__New(appState, this.appName, cache, assets, tmpDir)
    }
}
