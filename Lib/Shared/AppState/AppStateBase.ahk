class AppStateBase {
    stateMap := Map()
    stateLoaded := false

    State {
        get => this.GetState()
        set => this.stateMap := this.SaveState(value)
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

    __New(state := "", autoLoad := false) {
        if (state != "") {
            this.stateMap := state
        }

        if (autoLoad) {
            this.LoadState()
        }
    }

    SetVersions(versions) {
        this.State["Versions"] := versions
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

    SaveState(newState := "") {
        if (newState != "") {
            this.stateMap := newState
        }

        return this.stateMap
    }

    LoadState() {
        this.stateLoaded := true
        return this.stateMap
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

    GetState() {
        stateMap := this.stateLoaded ? this.stateMap : this.LoadState()
        return stateMap
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
