class StateBase {
    app := ""
    stateMap := Map()
    stateLoaded := false

    State {
        get => this.GetState()
        set => this.stateMap := this.SaveState(value)
    }

    __New(app, state := "", autoLoad := false) {
        InvalidParameterException.CheckTypes("StateBase", "app", app, "AppBase")
        
        this.app := app

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
        throw(MethodNotImplementedException.new("StateBase", "SaveState"))
    }

    LoadState() {
        throw(MethodNotImplementedException.new("StateBase", "LoadState"))
    }
}
