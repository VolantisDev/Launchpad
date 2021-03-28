class LaunchpadAppState extends JsonState {
    LaunchpadInstallDir {
        get => this.State.Has("LaunchpadInstallDir") ? this.State["LaunchpadInstallDir"] : ""
        set => this.State["LaunchpadInstallDir"] := value
    }
    
    Versions {
        get => this.State.Has("Versions") ? this.State["Versions"] : this.State["Versions"] := Map()
        set => this.SetVersions(value)
    }

    InstalledComponents {
        get => this.State.Has("InstalledComponents") ? this.State["InstalledComponents"] : this.State["InstalledComponents"] := Map()
        set => this.SetInstalledComponents(value)
    }

    LastUpdateChecks {
        get => this.State.Has("LastUpdateChecks") ? this.State["LastUpdateChecks"] : this.State["LastUpdateChecks"] := Map()
        set => this.SetLastUpdateChecks(value)
    }

    Authentication {
        get => this.State.Has("Authentication") ? this.State["Authentication"] : this.State["Authentication"] := Map()
        set => this.SetAuthentication(value)
    }

    Launchers {
        get => this.State.Has("Launchers") ? this.State["Launchers"] : this.State["Launchers"] := Map()
        set => this.SetLaunchers(value)
    }

    /**
    * IMPLEMENTED METHODS
    */

    SetVersions(versions) {
        this.State["Versions"] := versions
        this.SaveState()
    }

    SetAuthentication(authentication) {
        this.State["Authentication"] := authentication
        this.SaveState()
    }

    SetInstalledComponents(components) {
        this.State["InstalledComponents"] := components
        this.SaveState()
    }

    SetLastUpdateChecks(components) {
        this.State["LastUpdateChecks"] := components
        this.SaveState()
    }

    SetLastUpdateCheck(key, timestamp := "") {
        if (timestamp == "") {
            timestamp := FormatTime(,"yyyyMMddHHmmss")
        }

        this.LastUpdateChecks[key] := timestamp
    }

    GetLastUpdateCheck(key) {
        return (this.LastUpdateChecks.Has(key)) ? this.LastUpdateChecks[key] : ""
    }

    SetVersion(key, version := "") {
        if (version == "") {
            version := FormatTime(,"yyyyMMddHHmmss")
        }

        this.Versions[key] := version
        this.SaveState()
        return true
    }

    GetVersion(key) {
        return (this.Versions.Has(key)) ? this.Versions[key] : ""
    }

    RemoveVersion(key) {
        if (this.Versions.Has(key)) {
            this.Versions.Remove(key)
            this.SaveState()
        }
        return true
    }

    IsComponentInstalled(key) {
        return this.InstalledComponents.Has(key) ? this.InstalledComponents[key] : false
    }

    SetComponentInstalled(key, installed) {
        this.InstalledComponents[key] := installed
        this.SaveState()
    }

    SetLaunchers(versions) {
        this.State["Launchers"] := versions
        this.SaveState()
    }

    SetLauncherConfigInfo(launcherKey, version := "", timestamp := "") {
        this.SetLauncherInfo(launcherKey, "Config", version, timestamp)
    }

    SetLauncherBuildInfo(launcherKey, version := "", timestamp := "") {
        this.SetLauncherInfo(launcherKey, "Build", version, timestamp)
    }

    SetLauncherInfo(launcherKey, infoKey, version := "", timestamp := "") {
        if (version == "") {
            version := this.app.Version
        }

        if (timestamp == "") {
            timestamp := FormatTime(,"yyyyMMddHHmmss")
        }

        if (!this.Launchers.Has(launcherKey)) {
            this.Launchers[launcherKey] := Map()
        }

        this.Launchers[launcherKey][infoKey] := Map("Version", version, "Timestamp", timestamp)
        this.SaveState()
    }

    DeleteLauncherInfo(launcherKey, infoKey := "") {
        if (this.Launchers.Has(launcherKey)) {
            if (infoKey != "" && this.Launchers[launcherKey].Has(infoKey)) {
                this.Launchers[launcherKey].Delete(infoKey)
            }

            if (infoKey == "" || this.Launchers.Count == 0) {
                this.Launchers.Delete(launcherKey)
            }

            this.SaveState()
        }
    }

    GetLauncherInfo(launcherKey, infoKey) {
        value := ""

        if (this.Launchers.Has(launcherKey) && this.Launchers[launcherKey].Has(infoKey)) {
            value := this.Launchers[launcherKey][infoKey]
        }

        if (Type(value) != "Map") {
            value := Map()
        }

        if (!value.Has("Version")) {
            value["Version"] := ""
        }

        if (!value.Has("Timestamp")) {
            value["Timestamp"] := ""
        }

        return value
    }
}
