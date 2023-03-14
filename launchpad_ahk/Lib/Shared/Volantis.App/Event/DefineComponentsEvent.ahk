class DefineComponentsEvent extends EventBase {
    components := ""

    Items {
        get => this.components
    }

    __New(eventName, components) {
        this.components := components
        super.__New(eventName)
    }

    Define(key, className) {
        this.components[key] := className
    }
}
