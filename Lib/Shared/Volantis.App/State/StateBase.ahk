class StateBase {
    app := ""
    container := ""
    stateMap := Map()
    stateLoaded := false

    State {
        get => this.GetState()
        set => this.stateMap := this.SaveState(value)
    }

    Version {
        get => this.State.Has("Version") ? this.State["Version"] : 0
        set => this.State["Version"] := value
    }

    IsStateOutdated() {
        return this.app["version_checker"].VersionIsOutdated(this.app.Version, this.Version)
    }

    __New(app, state := "", autoLoad := false) {
        InvalidParameterException.CheckTypes("StateBase", "app", app, "AppBase")
        
        this.app := app
        this.container := app.Services

        if (state != "") {
            InvalidParameterException.CheckTypes("StateBase", "state", state, "Map")
            this.stateMap := state
        }

        if (autoLoad) {
            this.LoadState()
        }
    }

    GetState() {
        stateMap := this.stateLoaded ? this.stateMap : this.LoadState()
        return stateMap
    }

    /**
    * ABSTRACT METHODS
    */

    SaveState(newState := "") {
        throw(MethodNotImplementedException("StateBase", "SaveState"))
    }

    LoadState() {
        return Map("Version", this.app.Version)
    }
}
