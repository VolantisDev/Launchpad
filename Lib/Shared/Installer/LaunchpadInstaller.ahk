class LaunchpadInstaller extends InstallerBase {
    name := "Launchpad Installer"
    parentComponent := "LaunchpadExe"

    __New(appState, cache, tmpDir := "") {
        assets := []
        assets.Push(LaunchpadUpdaterInstallerAsset.new(appState, "Updater", cache, this.appName, true, tmpDir, true))
        assets.Push(LaunchpadIniInstallerAsset.new(appState, "IniFile", cache, this.appName, false, tmpDir, false))
        assets.Push(LogoInstallerAsset.new(appState, "Logo", cache, this.appName, true, tmpDir, false))
        super.__New(appState, this.appName, cache, assets, tmpDir)
    }
}
