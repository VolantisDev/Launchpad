class AppState extends JsonState {
    Versions {
        get => this.State.Has("Versions") ? this.State["Versions"] : this.State["Versions"] := Map()
        set => this.SetVersions(value)
    }

    Authentication {
        get => this.State.Has("Authentication") ? this.State["Authentication"] : this.State["Authentication"] := Map()
        set => this.SetAuthentication(value)
    }

    InstalledComponents {
        get => this.State.Has("InstalledComponents") ? this.State["InstalledComponents"] : this.State["InstalledComponents"] := Map()
        set => this.SetInstalledComponents(value)
    }

    LastUpdateChecks {
        get => this.State.Has("LastUpdateChecks") ? this.State["LastUpdateChecks"] : this.State["LastUpdateChecks"] := Map()
        set => this.SetLastUpdateChecks(value)
    }

    WindowState {
        get => this.State.Has("WindowState") ? this.State["WindowState"] : this.State["WindowState"] := Map()
        set => this.SetWindowState(value)
    }

    SetVersions(versions) {
        this.State["Versions"] := versions
        this.SaveState()
    }

    SetAuthentication(authentication) {
        this.State["Authentication"] := authentication
        this.SaveState()
    }

    SetWindowState(windowState) {
        this.State["WindowState"] := windowState
        this.SaveState()
    }

    StoreWindowState(guiId, windowState) {
        this.WindowState[guiId] := windowState
        this.SaveState()
    }

    RetrieveWindowState(guiId) {
        return this.WindowState.Has(guiId) ? this.WindowState[guiId] : Map()
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
}
