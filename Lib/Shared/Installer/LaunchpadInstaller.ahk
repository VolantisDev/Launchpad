class LaunchpadInstaller extends InstallerBase {
    name := "Launchpad Installer"
    parentComponent := "LaunchpadExe"

    __New(appState, tmpDir := "") {
        assets := []
        assets.Push(CompiledInstallerAsset.new(this.appName . " Updater.exe", this.appName . " Updater.exe", appState, "Updater", this.appName, true, tmpDir))
        assets.Push(CompiledInstallerAsset.new(this.appName . ".ini", this.appName . ".ini", appState, "IniFile", this.appName, false, tmpDir))
        assets.Push(CompiledInstallerAsset.new("Graphics\Logo.png", "Graphics\Logo.png", appState, "Logo", this.appName, true, tmpDir))
        super.__New(appState, this.appName, assets, tmpDir)
    }
}
