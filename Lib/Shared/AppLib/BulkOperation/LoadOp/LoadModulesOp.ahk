class LoadModulesOp extends BulkOperationBase {
    moduleDirs := ""
    defaultModules := ""
    state := ""
    useProgress := false
    shouldNotify := false

    __New(app, moduleDirs, defaultModules, state, owner := "") {
        if (Type(moduleDirs) == "String") {
            moduleDirs := [moduleDirs]
        }

        if (!defaultModules) {
            defaultModules := Map()
        }

        this.moduleDirs := moduleDirs
        this.defaultModules := defaultModules
        this.state := state
        super.__New(app, owner)
    }

    RunAction() {
        modules := this.DiscoverModules()

        if (this.useProgress) {
            this.progress.SetRange(0, modules.Count)
        }
        index := 0

        for key, moduleClass in modules {
            index++
            this.StartItem(index, "Loading " . key . "...")
            exists := IsSet(moduleClass)

            if (exists) {
                this.results[key] := %moduleClass%(this.app)
            } else {
                this.results[key] := ""
            }
            
            this.FinishItem(index, exists, "Finished loading " . key . ".")
        }
    }

    DiscoverModules() {
        dirs := this.moduleDirs
        modules := this.defaultModules.Clone()

        for index, dir in dirs {
            Loop Files dir . "\*", "D" {
                moduleName := A_LoopFileName

                if (FileExist(A_LoopFileFullPath . "\" A_LoopFileName . "Module.ahk")) {
                    modules[A_LoopFileName] := A_LoopFileName . "Module"
                }
            }
        }

        return modules
    }
}
