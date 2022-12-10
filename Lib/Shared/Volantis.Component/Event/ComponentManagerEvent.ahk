class ComponentManagerEvent extends EventBase {
    ComponentManager := ""

    __New(eventName, componentManager) {
        this.ComponentManager := componentManager

        super.__New(eventName)
    }
}
