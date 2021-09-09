; This represents an object that can install a component of LauncherGen, or a launcher itself.
class InstallerBase {
    name := "Launchpad Installer"
    appName := "Launchpad"
    cache := ""
    onlyInstallWhenCompiled := false
    version := ""
    appState := ""
    stateKey := ""
    installerComponents := []
    scriptFile := ""
    scriptDir := ""
    tmpDir := ""
    parentComponent := ""

    __New(version, appState, stateKey, cache, components := "", tmpDir := "", cleanupFiles := "") {
        this.cache := cache
        this.version := version
        this.appState := appState
        this.stateKey := stateKey
        SplitPath(A_ScriptFullPath, &scriptFile, &scriptDir)
        this.scriptFile := scriptFile
        this.scriptDir := scriptDir

        if (Type(cleanupFiles) != "Array") {
            cleanupFiles := [cleanupFiles]
        }

        this.cleanupFiles := cleanupFiles

        if (tmpDir == "") {
            tmpDir := A_Temp . "\Launchpad\Installers"
        }

        this.tmpDir := tmpDir

        if (components != "") {
            this.addComponents(components)
        }
    }

    /**
    * IMPLEMENTED METHODS
    */

    AddComponents(components) {
        if (Type(components) != "Array") {
            components := [components]
        }

        for index, component in components {
            this.installerComponents.push(component)
        }
    }

    InstallOrUpdate(progress := "") {
        if (this.onlyInstallWhenCompiled && !A_IsCompiled) {
            return true
        }

        return this.IsInstalled() ? this.Update(progress) : this.Install(progress)
    }

    CountComponents() {
        return this.installerComponents.Length
    }

    Install(progress := "") {
        if (this.onlyInstallWhenCompiled && !A_IsCompiled) {
            return true
        }

        this.appState.SetVersion(this.stateKey, this.version)
        success := true

        if (progress != "") {
            progress.SetDetailText(this.name . " components installing...")
        }
        
        for index, component in this.installerComponents {
            if (progress != "") {
                progress.IncrementValue(1, this.name . " installing " . component.stateKey . "...")
            }

            if (!component.Exists() || component.IsOutdated()) {
                componentSuccess := component.Install()
                
                if (!componentSuccess) {
                    success := false
                }
            }
        }

        for index, cleanupFile in this.cleanupFiles {
            if (FileExist(cleanupFile)) {
                FileDelete(cleanupFile)
            }
        }

        this.appState.SetComponentInstalled(this.stateKey, success)

        return success
    }

    IsInstalled() {
        if (this.onlyInstallWhenCompiled && !A_IsCompiled) {
            return true
        }

        for index, component in this.installerComponents {
            if (!component.Exists()) {
                return false
            }
        }

        return (this.appState.IsComponentInstalled(this.stateKey))
    }

    Update(progress := "") {
        if (this.onlyInstallWhenCompiled && !A_IsCompiled) {
            return true
        }

        if (this.IsOutdated()) {
            this.Install(progress) ; Ideally update the install before calling super.Update() so that this doesn't run.
        }
    }

    IsOutdated() {
        isOutdated := true

        if (this.IsInstalled()) {
            installedVersion := this.appState.GetVersion(this.stateKey)
            isOutdated := (this.VersionIsOutdated(this.version, installedVersion))
        }

        if (!isOutdated) {
            for index, component in this.installerComponents {
                if (component.IsOutdated()) {
                    isOutdated := true
                }
            }
        }

        return isOutdated
    }

    VersionIsOutdated(latestVersion, installedVersion) {
        if (latestVersion == "{{VERSION}}" || installedVersion == "{{VERSION}}") {
            return latestVersion != installedVersion
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

    Uninstall(progress := "") {
        if (this.onlyInstallWhenCompiled && !A_IsCompiled) {
            return true
        }

        if (progress != "") {
            progress.SetDetailText(this.name . ": Uninstalling components")
        }

        for index, component in this.installerComponents {
            if (progress != "") {
                progress.IncrementValue(1)
            }

            component.Uninstall()
        }

        this.appState.RemoveVersion(this.stateKey)
        this.appState.SetComponentInstalled(this.stateKey, false)
        return true
    }
}
