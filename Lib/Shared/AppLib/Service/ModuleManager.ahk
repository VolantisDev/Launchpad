class ModuleManager extends ContainerServiceBase {
    registerEvent := Events.MODULES_REGISTER
    alterEvent := Events.MODULES_ALTER
    
    DispatchEvent(eventName, eventObj, extra := "", hwnd := "") {
        modules := this.GetAll()

        for key, module in modules {
            module.DispatchEvent(eventName, eventObj, extra, hwnd)
        }
    }

    CalculateDependencies() {

    }

    RegisterSubscribers() {
        modules := this.GetAll()

        for key, module in modules {
            subscribers := module.GetSubscribers()

            eventMgr := this.app.Service("EventManager")

            if (subscribers) {
                for eventName, eventSubscribers in subscribers {
                    if (eventSubscribers) {
                        for index, subscriber in eventSubscribers {
                            eventMgr.Register(eventName, this.app.Service("IdGenerator").Generate(), subscriber)
                        }
                    }
                }
            }
        }
    }

    LoadModules(config) {
        moduleDirs := this.GetModuleDirs(config)
        defaultModules := this.app.GetDefaultModules(config)

        op := LoadModulesOp.new(this.app, moduleDirs, defaultModules, this.app.State)
        op.Run()
        results := op.GetResults()

        for key, module in results {
            this.Set(key, module)
        }

        this.RegisterSubscribers()
        return this
    }

    GetModuleDirs(config) {
        dirs := []

        sharedDir := this.app.dataDir . "\Modules"

        if (DirExist(sharedDir)) {
            dirs.Push(sharedDir)
        }

        if (config.Has("modulesDir") && config["modulesDir"]) {
            dirs.Push(config["modulesDir"])
        }

        return dirs
    }
}
