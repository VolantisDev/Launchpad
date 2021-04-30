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

        SplitPath(A_ScriptFullPath, &scriptFile, &scriptDir)
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
        throw MethodNotImplementedException("InstallerComponentBase", "ExistsAction")
    }

    InstallAction() {
        throw MethodNotImplementedException("InstallerComponentBase", "InstallAction")
    }

    UninstallAction() {
        throw MethodNotImplementedException("InstallerComponentBase", "UninstallAction")
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

    SanitizeVersionString(version) {
        version := StrReplace(version, "-", ".")
        version := StrReplace(version, " ", ".")
        return version
    }

    VersionIsOutdated(latestVersion, installedVersion) {
        if (latestVersion == "{{VERSION}}" || installedVersion == "{{VERSION}}") {
            return latestVersion == installedVersion
        }

        splitLatestVersion := StrSplit(this.SanitizeVersionString(latestVersion), ".")
        splitInstalledVersion := StrSplit(this.SanitizeVersionString(installedVersion), ".")

        for (index, numPart in splitLatestVersion) {
            otherVersionPart := splitInstalledVersion.Has(index) ? splitInstalledVersion[index] : 0

            currentIsAlpha := false
            latestIsAlpha := false

            if (SubStr(numPart, 1, 1) == "a" && IsInteger(SubStr(numPart, 2))) {
                latestIsAlpha := true
                numPart := SubStr(numPart, 2)
            }

            if (SubStr(otherVersionPart, 1, 1) == "a" && IsInteger(SubStr(otherVersionPart, 2))) {
                currentIsAlpha := true
                otherVersionPart := SubStr(otherVersionPart, 2)
            }

            if (currentIsAlpha != latestIsAlpha) {
                return true
            } else if (!IsInteger(numPart) or !IsInteger(otherVersionPart)) {
                if (numPart != otherVersionPart) {
                    return true
                }
            } else if ((otherVersionPart + 0) > (numPart + 0)) {
                return false
            } else if ((otherVersionPart + 0) < (numPart + 0)) {
                return true
            }
        }

        return false
    }
}
