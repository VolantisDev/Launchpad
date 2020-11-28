class DownloadableInstallerAsset extends FileInstallerAssetBase {
    downloadUrl := ""

    __New(downloadUrl, zipped, destPath, appState, stateKey, parentStateKey := "", overwrite := false, tmpDir := "") {
        this.zipped := zipped
        this.downloadUrl := downloadUrl
        super.__New(destPath, appState, stateKey, parentStateKey, overwrite, tmpDir)
    }

    InstallAction() {
        destPath := this.zipped ? this.tmpDir . "\" . this.tmpFile : this.GetDestPath()
        Download(this.GetDownloadUrl(), destPath)
        return super.InstallAction()
    }

    GetDownloadUrl() {
        return this.getDownloadUrl
    }
}
