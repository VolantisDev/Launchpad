class LogoInstallerAsset extends FileInstallerAssetBase {
    __New(appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        super.__New("Graphics\Logo.png", appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)
    }

    InstallFilesAction() {
        if (this.overwrite and this.destPath != "Graphics\Logo.png" and FileExist(this.destPath)) {
            FileDelete(this.destPath)
        }

        if (!FileExist(this.destPath)) {
            FileInstall "Graphics\Logo.png", "Graphics\Logo.png", !!(this.overwrite)
        }
        
        return super.InstallFilesAction()
    }
}
