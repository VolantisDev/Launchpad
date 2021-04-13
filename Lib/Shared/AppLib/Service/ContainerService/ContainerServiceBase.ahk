class ContainerServiceBase extends AppServiceBase {
    eventManagerObj := ""
    container := ""
    componentsLoaded := false
    registerEvent := ""
    alterEvent := ""

    __New(app, components := "", autoLoad := true) {
        this.container := ServiceComponentContainer.new(components)
        super.__New(app)

        if (autoLoad) {
            this.LoadComponents()
        }
    }

    LoadComponents() {
        if (!this.componentsLoaded) {
            if (this.registerEvent) {
                event := RegisterComponentsEvent.new(this.registerEvent, this.container)
                this.app.Service("EventManager").DispatchEvent(this.registerEvent, event)
                this.container := event.container
            }

            if (this.alterEvent) {
                event := AlterComponentsEvent.new(this.alterEvent, this.container)
                this.app.Service("EventManager").DispatchEvent(this.alterEvent, event)
                this.container := event.container
            }

            this.componentsLoaded := true
        }
    }

    Get(key) {
        return this.container.Get(key)
    }

    GetAll() {
        return this.container.Items
    }

    Set(key, componentObj) {
        this.container.Set(key, componentObj)
    }

    Remove(key) {
        this.container.Delete(key)
    }
}
