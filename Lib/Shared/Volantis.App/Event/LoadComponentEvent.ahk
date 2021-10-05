class LoadComponentEvent extends EventBase {
    Component := ""
    ComponentInfo := ""
    ComponentKey := ""

    __New(eventName, componentKey, componentInfo := "") {
        this.componentKey := componentKey
        this.componentInfo := componentInfo
        super.__New(eventName)
    }

    SetComponent(component) {
        this.Component := component
    }
}
