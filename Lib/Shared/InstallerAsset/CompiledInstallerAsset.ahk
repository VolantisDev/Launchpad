class CompiledInstallerAsset extends FileInstallerAssetBase {
    sourcePath := ""

    __New(sourcePath, destPath, appState, stateKey, parentStateKey := "", overwrite := false, tmpDir := "") {
        this.sourcePath := sourcePath
        super.__New(destPath, appState, stateKey, parentStateKey, overwrite, tmpDir)
    }

    InstallAction() {
        FileInstall(this.sourcePath, this.GetDestPath(), this.overwrite)
        return super.InstallAction()
    }
}
