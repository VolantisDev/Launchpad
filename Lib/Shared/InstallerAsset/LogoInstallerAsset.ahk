class LogoInstallerAsset extends FileInstallerAssetBase {
    __New(appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        super.__New("Graphics\Logo.png", appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)
    }

    InstallFilesAction() {
        FileInstall "Graphics\Logo.png", "Graphics\Logo.png", !!(this.overwrite)
        return super.InstallFilesAction()
    }
}
