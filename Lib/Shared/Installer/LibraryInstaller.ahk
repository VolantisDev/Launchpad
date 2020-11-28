class LibraryInstaller extends InstallerBase {
    name := "Launchpad Library Installer"
    onlyInstallWhenCompiled := true

    __New(appState, tmpDir := "") {
        assets := []
        assets.Push(CompiledInstallerAsset.new("Lib\Shared", "Lib\Shared", appState, "SharedLib", "Libraries", true, tmpDir))
        assets.Push(CompiledInstallerAsset.new("Lib\LauncherLib", "Lib\LauncherLib", appState, "LauncherLib", "Libraries", true, tmpDir))
        super.__New(appState, "Libraries", assets, tmpDir)
    }
}
