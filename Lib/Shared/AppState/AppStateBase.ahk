class AppStateBase {
    stateMap := Map()
    stateLoaded := false

    State {
        get => (this.stateLoaded) ? this.stateMap : this.LoadState()
        set => this.stateMap := this.SaveState(newState)
    }

    Versions {
        get => this.State.Has("Versions") ? this.State["Versions"] : this.State["Versions"] := Map()
        set => this.SetVersions(value)
    }

    InstalledComponents {
        get => this.State.Has("InstalledComponents") ? this.State["InstalledComponents"] : this.State["InstalledComponents"] := Map()
        set => this.SetInstalledComponents(value)
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

    SaveState(newState := "") {
        if (newState != "") {
            this.stateMap := newState
        }

        return this.stateMap
    }

    LoadState() {
        return this.stateMap
    }

    SetVersion(key, version := "") {
        if (version == "") {
            version := FormatTime()
        }

        this.Versions[key] := version
        this.SaveState()
        return true
    }

    GetVersion(key) {
        if (this.Versions.Has(key)) {
            return this.Versions[key]
        }

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
