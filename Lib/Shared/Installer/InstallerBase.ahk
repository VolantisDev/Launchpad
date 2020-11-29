; This represents an object that can install a component of LauncherGen, or a launcher itself.
class InstallerBase {
    name := "Launchpad Installer"
    appName := "Launchpad"
    cache := ""
    onlyInstallWhenCompiled := false
    appState := ""
    stateKey := ""
    installerAssets := []
    scriptFile := ""
    scriptDir := ""
    tmpDir := ""
    parentComponent := ""

    __New(appState, stateKey, cache, assets := "", tmpDir := "") {
        this.cache := cache
        this.appState := appState
        this.stateKey := stateKey
        SplitPath(A_ScriptFullPath, scriptFile, scriptDir)
        this.scriptFile := scriptFile
        this.scriptDir := scriptDir

        if (tmpDir == "") {
            tmpDir := A_Temp . "\Launchpad\Installers"
        }

        this.tmpDir := tmpDir

        if (assets != "") {
            this.addAssets(assets)
        }
    }

    /**
    * IMPLEMENTED METHODS
    */

    AddAssets(assets) {
        if (Type(assets) != "Array") {
            assets := [assets]
        }

        for index, asset in assets {
            this.installerAssets.push(asset)
        }
    }

    InstallOrUpdate(progress := "") {
        if (this.onlyInstallWhenCompiled and !A_IsCompiled) {
            return true
        }

        return this.IsInstalled() ? this.Update(progress) : this.Install(progress)
    }

    CountAssets() {
        return this.installerAssets.Length
    }

    Install(progress := "") {
        if (this.onlyInstallWhenCompiled and !A_IsCompiled) {
            return true
        }

        this.appState.SetVersion(this.stateKey)
        success := true

        if (progress != "") {
            progress.SetDetailText(this.name . " components installing...")
        }
        
        for index, asset in this.installerAssets {
            if (progress != "") {
                progress.IncrementValue(1, this.name . " installing " . asset.stateKey . "...")
            }

            if (!asset.Exists() || asset.IsOutdated()) {
                assetSuccess := asset.Install()
                
                if (!assetSuccess) {
                    success := false
                }
            }
        }

        this.appState.SetComponentInstalled(this.stateKey, success)

        return success
    }

    IsInstalled() {
        if (this.onlyInstallWhenCompiled and !A_IsCompiled) {
            return true
        }

        for index, asset in this.installerAssets {
            if (!asset.Exists()) {
                return false
            }
        }

        return (this.appState.IsComponentInstalled(this.stateKey))
    }

    Update(progress := "") {
        if (this.onlyInstallWhenCompiled and !A_IsCompiled) {
            return true
        }

        if (this.IsOutdated()) {
            this.Install(progress) ; Ideally update the install before calling super.Update() so that this doesn't run.
        }
    }

    IsOutdated() {
        isOutdated := true

        if (this.IsInstalled() and this.parentComponent != "") {
            parentLastInstalled := this.appState.GetVersion(this.parentComponent)
            lastInstalled := this.appState.GetVersion(this.stateKey)
            isOutdated := (this.VersionIsOutdated(parentLastInstalled, lastInstalled))
        }

        if (!isOutdated) {
            for index, asset in this.installerAssets {
                if (asset.IsOutdated()) {
                    isOutdated := true
                }
            }
        }

        return isOutdated
    }

    VersionIsOutdated(latestVersion, installedVersion) {
        splitLatestVersion := StrSplit(latestVersion, ".")
        splitInstalledVersion := StrSplit(installedVersion, ".")

        for (index, numPart in splitInstalledVersion) {
            latestVersionPart := splitLatestVersion.Has(index) ? splitLatestVersion[index] : 0

            if ((latestVersionPart + 0) > (numPart + 0)) {
                return true
            } else if ((latestVersionPart + 0) < (numPart + 0)) {
                return false
            } 
        }

        return false
    }

    Uninstall(progress := "") {
        if (this.onlyInstallWhenCompiled and !A_IsCompiled) {
            return true
        }

        if (progress != "") {
            progress.SetDetailText(this.name . ": Uninstalling assets")
        }

        for index, asset in this.installerAssets {
            if (progress != "") {
                progress.IncrementValue(1)
            }

            asset.Uninstall()
        }

        this.appState.RemoveVersion(this.stateKey)
        this.appState.SetComponentInstalled(this.stateKey, false)
        return true
    }
}
