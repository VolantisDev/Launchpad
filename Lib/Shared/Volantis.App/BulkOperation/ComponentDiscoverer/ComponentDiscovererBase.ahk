class ComponentDiscovererBase extends BulkOperationBase {
    componentName := "component"
    componentNamePlural := "components"
    useProgress := false
    shouldNotify := false
    componentManager := ""

    __New(componentManager, owner := "") {      
        this.componentManager := componentManager
        super.__New(componentManager.app, owner)
    }

    RunAction() {
        this.StartItem(1, "Discovering " . this.componentNamePlural . "...")
        this.results := this.CreateComponentInfo()
        this.DiscoverComponents()
        this.FinishItem(1, "Finished discovering " . this.componentNamePlural . ".")
    }

    CreateComponentInfo() {
        componentInfo := this.componentManager.defaultComponentInfo ? this.componentManager.defaultComponentInfo : Map()
        return componentInfo.Clone()
    }

    DiscoverComponents() {
        if (this.componentManager.discoverEvent) {
            event := ComponentInfoEvent(this.componentManager.discoverEvent, this.results)
            this.app.Service("EventManager").DispatchEvent(this.componentManager.discoverEvent, event)
            this.results := event.ComponentInfo
        }

        if (this.componentManager.discoverAlterEvent) {
            event := ComponentInfoEvent(this.componentManager.discoverAlterEvent, this.results)
            this.app.Service("EventManager").DispatchEvent(this.componentManager.discoverAlterEvent, event)
            this.results := event.ComponentInfo
        }
    }
}
