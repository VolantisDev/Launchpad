class SharedLibInstallerAsset extends FileInstallerAssetBase {
    zipped := true

    __New(appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        super.__New("Lib\Shared", appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)
    }

    InstallFilesAction() {
        if (this.overwrite and this.destPath != "Build\SharedLib.zip" and FileExist(this.destPath)) {
            FileDelete(this.destPath)
        }

        if (!FileExist(this.destPath)) {
            FileInstall "Build\SharedLib.zip", this.GetTmpFile(), !!(this.overwrite)
        }

        return super.InstallFilesAction()
    }
}
