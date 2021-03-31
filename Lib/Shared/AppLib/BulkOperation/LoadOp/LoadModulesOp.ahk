class LoadModulesOp extends BulkOperationBase {
    moduleDirs := ""
    state := ""
    progressTitle := "Adding Selected Games"
    progressText := "Please wait while Launchpad adds the selected games..."
    notify := true
    successMessage := "Added {n} games."
    failedMessage := "Failed to add {n} games."

    __New(app, moduleDirs, state, owner := "") {
        if (Type(moduleDirs) == "String") {
            moduleDirs := [moduleDirs]
        }

        this.moduleDirs := moduleDirs
        this.state := state
        super.__New(app, owner)
    }

    RunAction() {
        if (this.useProgress) {
            this.progress.SetRange(0, this.moduleDirs.Count)
        }

        if (!this.state.State.Has("Modules")) {
            this.state.State["Modules"] := Map()
        }

        for index, moduleDir in this.moduleDirs {
            this.StartItem(index, "Loading modules from " . moduleDir . "...")
            ; @todo Determine best way to dynamically load ahk files from a compiled script
            ; @todo populate this.results with a map of all loaded modules
            this.FinishItem(index, true, "Finished loading modules from " . moduleDir . ".")
        }

        this.state.SaveState()
    }
}
