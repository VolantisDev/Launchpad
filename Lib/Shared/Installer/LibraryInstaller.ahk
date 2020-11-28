class LibraryInstaller extends InstallerBase {
    name := "Launchpad Library Installer"
    onlyInstallWhenCompiled := true

    __New(appState, cache, tmpDir := "") {
        assets := []
        assets.Push(SharedLibInstallerAsset.new(appState, cache, "SharedLib", "Libraries", true, tmpDir, true))
        assets.Push(LauncherLibInstallerAsset.new(appState, cache, "LauncherLib", "Libraries", true, tmpDir, true))
        super.__New(appState, "Libraries", cache, assets, tmpDir)
    }
}
