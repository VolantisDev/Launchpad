class LaunchpadInstaller extends InstallerBase {
    name := "Launchpad Installer"
    parentComponent := "LaunchpadExe"

    __New(appState, cache, tmpDir := "") {
        assets := []
        ;assets.Push(LaunchpadUpdaterInstallerAsset.new(appState, cache, "Updater", this.appName, true, tmpDir, true))
        ;assets.Push(LaunchpadIniInstallerAsset.new(appState, cache, "IniFile", this.appName, false, tmpDir, false))
        ;assets.Push(LogoInstallerAsset.new(appState, cache, "Logo", this.appName, true, tmpDir, false))
        super.__New(appState, this.appName, cache, assets, tmpDir)
    }
}
