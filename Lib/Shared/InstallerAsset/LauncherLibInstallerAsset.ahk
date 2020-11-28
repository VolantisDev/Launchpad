class LauncherLibInstallerAsset extends FileInstallerAssetBase {
    zipped := true

    __New(appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        super.__New("Lib\LauncherLib", appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)
    }

    InstallFilesAction() {
        FileInstall "Build\LauncherLib.zip", this.GetTmpFile(), !!(this.overwrite)
        return super.InstallFilesAction()
    }
}
