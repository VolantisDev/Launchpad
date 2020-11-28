class LaunchpadIniInstallerAsset extends FileInstallerAssetBase {
    __New(appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        super.__New("Launchpad.ini", appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)
    }
    
    InstallFilesAction() {
        if (this.overwrite and this.destPath != "Examples\Launchpad.ini.example" and FileExist(this.destPath)) {
            FileDelete(this.destPath)
        }

        if (!FileExist(this.destPath)) {
            FileInstall "Examples\Launchpad.ini.example", this.destPath, !!(this.overwrite)
        }
        
        return super.InstallFilesAction()
    }
}
