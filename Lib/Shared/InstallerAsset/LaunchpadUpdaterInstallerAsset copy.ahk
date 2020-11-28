class LaunchpadUpdaterInstallerAsset extends FileInstallerAssetBase {
    __New(appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        super.__New("Launchpad Updater.exe", appState, stateKey, cache, parentStateKey, overwrite, tmpDir, onlyCompiled)
    }

    InstallFilesAction() {
        if (this.overwrite and this.destPath != "Launchpad Updater.exe" and FileExist(this.destPath)) {
            FileDelete(this.destPath)
        }

        if (!FileExist(this.destPath)) {
            FileInstall "Launchpad Updater.exe", "Launchpad Updater.exe", !!(this.overwrite)
        }

        return super.InstallFilesAction()
    }
}
