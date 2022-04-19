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

    GetLauncherCreated(launcherId) {
        created := ""

        if (this.Launchers.Has(launcherId) && this.Launchers[launcherId].Has("Created")) {
            created := this.Launchers[launcherId]["Created"]
        }

        return created
    }

    SetLauncherCreated(launcherId, timestamp := "") {
        if (timestamp == "") {
            timestamp := FormatTime(,"yyyyMMddHHmmss")
        }

        if (!this.Launchers.Has(launcherId)) {
            this.Launchers[launcherId] := Map()
        }

        this.Launchers[launcherId]["Created"] := timestamp
        this.SaveState()
    }

    SetLauncherConfigInfo(launcherId, version := "", timestamp := "") {
        this.SetLauncherInfo(launcherId, "Config", version, timestamp)
    }

    SetLauncherBuildInfo(launcherId, version := "", timestamp := "") {
        this.SetLauncherInfo(launcherId, "Build", version, timestamp)
    }

    SetLauncherInfo(launcherId, infoKey, version := "", timestamp := "") {
        if (version == "") {
            version := this.app.Version
        }

        if (timestamp == "") {
            timestamp := FormatTime(,"yyyyMMddHHmmss")
        }

        if (!this.Launchers.Has(launcherId)) {
            this.Launchers[launcherId] := Map()
        }

        this.Launchers[launcherId][infoKey] := Map("Version", version, "Timestamp", timestamp)
        this.SaveState()
    }

    DeleteLauncherInfo(launcherId, infoKey := "") {
        if (this.Launchers.Has(launcherId)) {
            if (infoKey != "" && this.Launchers[launcherId].Has(infoKey)) {
                this.Launchers[launcherId].Delete(infoKey)
            }

            if (infoKey == "" || this.Launchers.Count == 0) {
                this.Launchers.Delete(launcherId)
            }

            this.SaveState()
        }
    }

    GetLauncherInfo(launcherId, infoKey) {
        value := ""

        if (this.Launchers.Has(launcherId) && this.Launchers[launcherId].Has(infoKey)) {
            value := this.Launchers[launcherId][infoKey]
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
