class ComponentLoaderBase extends BulkOperationBase {
    componentInfo := ""
    useProgress := false
    shouldNotify := false
    componentManager := ""

    __New(componentManager, componentInfo, owner := "") {
        this.componentManager := componentManager
        this.componentInfo := componentInfo

        super.__New(componentManager.app, owner)
    }

    RunAction() {
        componentInfoType := Type(this.componentInfo)

        if (this.componentManager.defaultComponents) {
            for defaultKey, defaultComponent in this.componentManager.defaultComponents {
                this.results[defaultKey] := defaultComponent
            }
        }
        
        if (this.useProgress) {
            totalCount := 1

            if (componentInfoType == "Map") {
                totalCount := this.componentInfo.Count
            } else if (componentInfoType == "Array") {
                totalCount := this.componentInfo.Length
            }

            this.progress.SetRange(0, totalCount)
        }

        if (componentInfoType == "Map") {
            index := 1

            for key, info in this.componentInfo {
                this.StartItem(index, "Loading " . key . "...")
                this.LoadComponent(key, info)
                this.FinishItem(index, "Finished loading " . key)
                index++
            }
        } else if (componentInfoType == "Array") {
            for index, info in this.componentInfo {
                this.StartItem(index, "Loading component " . index . "...")
                this.LoadComponent(index, info)
                this.FinishItem(index, "Finished loading component " . index)
            }
        } else {
            this.StartItem(1, "Loading component...")
            this.LoadComponent(1, this.componentInfo)
            this.FinishItem(1, "Finished loading component")
        }
    }

    /*
        This method should be called AFTER any overridden method loads the component.

        It calls a load event if the component has not been loaded already.
        Then it calls an alter event allowing the component to be modified or replaced.
    */
    LoadComponent(key, componentInfo) {
        if (this.componentManager.loadEvent && (!this.results.Has(key) || !this.results[key])) {
            event := LoadComponentEvent(this.componentManager.loadEvent, key, componentInfo)
            this.app.Service("EventManager").DispatchEvent(this.componentManager.loadEvent, event)
            
            if (event.Component) {
                this.results[key] := event.Component
            }
        }

        if (this.componentManager.loadAlterEvent) {
            event := LoadComponentEvent(this.componentManager.loadAlterEvent, key, componentInfo)
            
            if (this.results.Has(key)) {
                event.Component := this.results[key]
            }

            this.app.Service("EventManager").DispatchEvent(this.componentManager.loadAlterEvent, event)

            this.results[key] := event.Component
        }
    }
}
