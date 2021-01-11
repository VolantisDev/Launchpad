class DownloadableInstallerComponent extends FileInstallerComponentBase {
    downloadUrl := ""

    __New(version, downloadUrl, zipped, destPath, appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        this.zipped := zipped
        this.downloadUrl := downloadUrl
        super.__New(version, destPath, appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)
    }

    InstallFilesAction() {
        destPath := this.zipped ? this.tmpDir . "\" . this.tmpFile : this.GetDestPath()

        downloadUrl := this.GetDownloadUrl()
        
        if (downloadUrl == "") {
            throw AppException.new("Failed to determine download URL of installer component " . this.stateKey)
        }

        Download(this.GetDownloadUrl(), destPath)
        return true
    }

    GetDownloadUrl() {
        return this.downloadUrl
    }
}
