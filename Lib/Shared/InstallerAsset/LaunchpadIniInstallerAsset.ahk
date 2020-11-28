class LaunchpadIniInstallerAsset extends FileInstallerAssetBase {
    __New(appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        super.__New("Launchpad.ini", appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)
    }
    
    InstallFilesAction() {
        FileInstall "Launchpad.default.ini", "Launchpad.ini", !!(this.overwrite)
        return super.InstallFilesAction()
    }
}
