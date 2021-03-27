class AlterComponentsEvent extends EventBase {
    container := ""

    Items {
        get => this.container.Items
    }

    __New(eventName, container) {
        this.container := container
        super.__New(eventName)
    }
}
