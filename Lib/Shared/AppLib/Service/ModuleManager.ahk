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

            eventMgr := this.app.Events

            if (subscribers) {
                for eventName, eventSubscribers in subscribers {
                    if (eventSubscribers) {
                        for index, subscriber in eventSubscribers {
                            eventMgr.Register(eventName, this.app.IdGen.Generate(), subscriber)
                        }
                    }
                }
            }
        }
    }

    LoadModules(modules) {
        for moduleName, moduleDir in modules {
            modulePath := moduleDir . "\" . moduleName . "Module.ahk"
          
            if (!FileExist(modulePath)) {
                continue
            }

            if (!IsSet(moduleName)) {
                throw AppException.new("Module " . moduleName . " does not seem to be loaded. Try rebuilding your include files and restarting.")
            }
            className := moduleName . "Module"
            this.Set(moduleName, %className%.new(this.app))
        }
    }
}
