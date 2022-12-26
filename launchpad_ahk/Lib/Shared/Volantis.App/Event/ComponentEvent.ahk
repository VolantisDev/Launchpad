class ComponentEvent extends EventBase {
    container := ""

    Items {
        get => this.container.Items
    }

    __New(eventName, container) {
        this.container := container
        super.__New(eventName)
    }

    Register(key, componentObj) {
        this.container.Set(key, componentObj)
    }
}
