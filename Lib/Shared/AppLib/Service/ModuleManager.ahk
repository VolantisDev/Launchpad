class ModuleManager extends ContainerServiceBase {
    registerEvent := Events.MODULES_REGISTER
    alterEvent := Events.MODULES_ALTER
    
    DispatchEvent(eventName, eventObj, extra := "", hwnd := "") {
        modules := this.GetAll()

        for key, module in modules {
            module.DispatchEvent(eventName, eventObj, extra, hwnd)
        }
    }
}
