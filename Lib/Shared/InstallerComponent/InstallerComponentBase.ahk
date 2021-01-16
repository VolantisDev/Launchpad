class InstallerComponentBase {
    appState := ""
    cache := ""
    stateKey := ""
    parentStateKey := ""
    scriptFile := ""
    scriptDir := ""
    overwrite := false
    tmpDir := ""
    tmpFile := ""
    version := ""
    onlyCompiled := false

    __New(version, appState, stateKey, cache, parentStateKey := "", overwrite := false, tmpDir := "", onlyCompiled := false) {
        this.version := version
        this.cache := cache
        
        if (!tmpDir) {
            tmpDir := A_Temp . "\Launchpad\Installers"
        }

        if (this.tmpFile == "") {
            this.tmpFile := "Installer" . Random()
        }


        this.stateKey := stateKey
        this.appState := appState
        this.overwrite := overwrite

        SplitPath(A_ScriptFullPath, scriptFile, scriptDir)
        this.scriptFile := scriptFile
        this.scriptDir := scriptDir
        this.tmpDir := tmpDir
        this.onlyCompiled := onlyCompiled

        DirCreate(tmpDir)
    }

    /**
    * ABSTRACT METHODS
    */

    ExistsAction() {
        throw MethodNotImplementedException.new("InstallerComponentBase", "ExistsAction")
    }

    InstallAction() {
        throw MethodNotImplementedException.new("InstallerComponentBase", "InstallAction")
    }

    UninstallAction() {
        throw MethodNotImplementedException.new("InstallerComponentBase", "UninstallAction")
    }

    /**
    * IMPLEMENTED METHODS
    */

    Exists() {
        if (this.onlyCompiled && !A_IsCompiled) {
            return true
        }

        exists := this.ExistsAction()

        return (exists && this.appState.GetVersion(this.stateKey) != "" && this.appState.IsComponentInstalled(this.stateKey))
    }

    Install() {
        if (this.onlyCompiled && !A_IsCompiled) {
            return true
        }

        this.InstallAction()

        this.appState.SetVersion(this.stateKey, this.version)
        this.appState.SetComponentInstalled(this.stateKey, true)
        return true
    }

    Uninstall() {
        if (this.onlyCompiled && !A_IsCompiled) {
            return true
        }

        this.UninstallAction()

        this.appState.RemoveVersion(this.stateKey)
        this.appState.SetComponentInstalled(this.stateKey, false)

        return true
    }

    IsOutdated() {
        if (this.onlyCompiled && !A_IsCompiled) {
            return false
        }

        isOutdated := true

        if (this.Exists()) {
            componentVersion := this.appState.GetVersion(this.stateKey)
            isOutdated := this.VersionIsOutdated(this.version, componentVersion)
        }

        this.appState.SetLastUpdateCheck(this.stateKey)

        return isOutdated
    }

    GetParentVersion() {
        return this.appState.GetVersion(this.parentStateKey)
    }

    VersionIsOutdated(latestVersion, installedVersion) {
        if (latestVersion == "{{VERSION}}" || installedVersion == "{{VERSION}}") {
            return latestVersion == "{{VERSION}}" && installedVersion == "{{VERSION}}"
        }

        splitLatestVersion := StrSplit(latestVersion, ".")
        splitInstalledVersion := StrSplit(installedVersion, ".")

        for (index, numPart in splitInstalledVersion) {
            latestVersionPart := splitLatestVersion.Has(index) ? splitLatestVersion[index] : 0

            if (!IsInteger(numPart) or !IsInteger(latestVersionPart)) {
                if (numPart != latestVersionPart) {
                    return true
                }
            } else if ((latestVersionPart + 0) > (numPart + 0)) {
                return true
            } else if ((latestVersionPart + 0) < (numPart + 0)) {
                return false
            }
        }

        return false
    }
}
