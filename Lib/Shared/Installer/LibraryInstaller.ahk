class LibraryInstaller extends InstallerBase {
    name := "Launchpad Library Installer"
    onlyInstallWhenCompiled := true
    version := "latest"

    __New(appState, cache, tmpDir := "") {
        assets := []
        asset := GitHubReleaseInstallerAsset.new("VolantisDev/Launchpad", "Launchpad Lib.zip", true, "Lib", appState, "LibDirs", cache, "Libraries", true, tmpDir, true)
        asset.version := this.version
        assets.Push(asset)
        super.__New(appState, "Libraries", cache, assets, tmpDir)
    }
}
