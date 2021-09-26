class ComponentInfoEvent extends EventBase {
    ComponentInfo := Map()

    __New(eventName, componentInfo := "") {
        if (componentInfo) {
            this.ComponentInfo := componentInfo
        }

        super.__New(eventName)
    }

    Register(key, componentObj) {
        this.ComponentInfo[key] := componentObj
    }
}
