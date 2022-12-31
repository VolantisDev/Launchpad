class ParameterState extends StateBase {
    parameterKey := ""

    __New(app, parameterKey, autoLoad := false) {
        this.parameterKey := parameterKey
        super.__New(app, "", autoLoad)
    }

    SaveState(newState := "") {
        if (newState != "") {
            this.stateMap := newState
        }

        if (this.parameterKey) {
            this.container.Parameters[this.parameterKey] := this.stateMap
        }
        
        return this.stateMap
    }

    LoadState() {
        if (this.parameterKey && !this.stateLoaded) {
            newState := super.LoadState()

            if (this.container.HasParameter(this.parameterKey)) {
                paramValue := this.container.Parameters[this.parameterKey]

                if (HasBase(paramValue, Map.Prototype)) {
                    newState := paramValue
                }
            }

            this.stateMap := newState
            this.stateLoaded := true
        }
        
        return this.stateMap
    }
}
