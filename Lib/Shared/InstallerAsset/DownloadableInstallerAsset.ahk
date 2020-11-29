class DownloadableInstallerAsset extends FileInstallerAssetBase {
    downloadUrl := ""

    __New(downloadUrl, zipped, destPath, appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        this.zipped := zipped
        this.downloadUrl := downloadUrl
        super.__New(destPath, appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)
    }

    InstallFilesAction() {
        destPath := this.zipped ? this.tmpDir . "\" . this.tmpFile : this.GetDestPath()
        Download(this.GetDownloadUrl(), destPath)
        return true
    }

    GetDownloadUrl() {
        return this.downloadUrl
    }
}
