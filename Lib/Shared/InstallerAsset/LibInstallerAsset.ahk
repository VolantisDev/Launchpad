class LauncherLibInstallerAsset extends FileInstallerAssetBase {
    zipped := true

    __New(appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        super.__New("Lib", appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)
    }

    InstallFilesAction() {
        if (this.overwrite and this.destPath != "Build\LauncherLib.zip" and FileExist(this.destPath)) {
            FileDelete(this.destPath)
        }

        if (!FileExist(this.destPath)) {
            ;FileInstall "Build\LauncherLib.zip", this.GetTmpFile(), !!(this.overwrite)
        }

        return true
    }
}
