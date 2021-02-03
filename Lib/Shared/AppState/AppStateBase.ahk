class AppStateBase {
    stateMap := Map()
    stateLoaded := false

    State {
        get => this.GetState()
        set => this.stateMap := this.SaveState(value)
    }

    __New(state := "", autoLoad := false) {
        if (state != "") {
            InvalidParameterException.CheckTypes("AppStateBase", "state", state, "Map")
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
        throw(MethodNotImplementedException.new("AppStateBase", "SaveState"))
    }

    LoadState() {
        throw(MethodNotImplementedException.new("AppStateBase", "LoadState"))
    }
}
