class InstallerAssetBase {
    appState := ""
    stateKey := ""
    parentStateKey := ""
    scriptFile := ""
    scriptDir := ""
    overwrite := false
    tmpDir := ""
    tmpFile := ""
    version := ""

    __New(appState, stateKey, parentStateKey := "", overwrite := false, tmpDir := "") {
        if (tmpDir == "") {
            tmpDir := A_Temp . "\Launchpad\Installers"
        }

        if (tmpFile == "") {
            tmpFile := "Installer" . Random()
        }


        this.stateKey := stateKey
        this.appState := appState
        this.overwrite := overwrite

        SplitPath(A_ScriptFullPath, scriptFile, scriptDir)
        this.scriptFile := scriptFile
        this.scriptDir := scriptDir
        this.tmpDir := tmpDir
        this.tmpFile := tmpFile

        DirCreate(tmpDir)
    }

    Exists() {
        return (this.appState.GetVersion(this.stateKey) != "" and this.appState.IsComponentInstalled(this.stateKey))
    }

    Install() {
        this.appState.SetVersion(this.stateKey, this.version)
        this.appState.SetComponentInstalled(this.stateKey, true)
        return true
    }

    Uninstall() {
        this.appState.RemoveVersion(this.stateKey)
        this.appState.SetComponentInstalled(this.stateKey, false)

        return true
    }

    IsOutdated() {
        isOutdated := true

        if (this.Exists() and this.parentStateKey != "") {
            assetVersion := this.appState.GetVersion(this.stateKey)
            parentVersion := this.GetParentVersion()
            isOutdated := this.VersionIsOutdated(parentVersion, assetVersion)
        }

        return isOutdated
    }

    GetParentVersion() {
        return this.appState.GetVersion(this.parentStateKey)
    }

    VersionIsOutdated(latestVersion,installedVersion) {
        splitLatestVersion := StrSplit(latestVersion,".")
        splitInstalledVersion:=StrSplit(installedVersion,".")

        for (index, numPart in splitInstalledVersion) {
            if ((splitLatestVersion[index] + 0) > (numPart + 0)) {
                return true
            } else if ((splitLatestVersion[index] + 0) < (numPart + 0)) {
                return false
            } 
        }

        return false
    }
}
