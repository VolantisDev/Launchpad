class CopyableInstallerComponent extends FileInstallerComponentBase {
    sourcePath := ""
    deleteZip := false

    __New(version, sourcePath, zipped, destPath, appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        this.zipped := zipped
        this.sourcePath := sourcePath
        super.__New(version, destPath, appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)
    }

    InstallFilesAction() {
        if (this.zipped) {
            this.zipFile := this.sourcePath
        } else {
            FileCopy(this.sourcePath, this.destPath, this.overwrite)
        }

        return true
    }

    GetSourcePath() {
        return this.sourcePath
    }
}
