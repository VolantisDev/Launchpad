class LaunchpadAppState extends AppState {
    LaunchpadInstallDir {
        get => this.State.Has("LaunchpadInstallDir") ? this.State["LaunchpadInstallDir"] : ""
        set => this.State["LaunchpadInstallDir"] := value
    }

    Launchers {
        get => this.State.Has("Launchers") ? this.State["Launchers"] : this.State["Launchers"] := Map()
        set => this.SetLaunchers(value)
    }

    /**
    * IMPLEMENTED METHODS
    */

    SetLaunchers(versions) {
        this.State["Launchers"] := versions
        this.SaveState()
    }

    GetLauncherCreated(launcherKey) {
        created := ""

        if (this.Launchers.Has(launcherKey) && this.Launchers[launcherKey].Has("Created")) {
            created := this.Launchers[launcherKey]["Created"]
        }

        return created
    }

    SetLauncherCreated(launcherKey, timestamp := "") {
        if (timestamp == "") {
            timestamp := FormatTime(,"yyyyMMddHHmmss")
        }

        if (!this.Launchers.Has(launcherKey)) {
            this.Launchers[launcherKey] := Map()
        }

        this.Launchers[launcherKey]["Created"] := timestamp
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

        if (!HasBase(value, Map.Prototype)) {
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
