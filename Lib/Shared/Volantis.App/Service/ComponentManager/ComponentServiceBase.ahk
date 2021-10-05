class ComponentServiceBase {
    eventManagerObj := ""
    _components := Map()
    _componentsLoaded := false
    _registerEvent := ""
    _alterEvent := ""

    __New(eventManagerObj, components := "", autoLoad := true) {
        this.eventManagerObj := eventManagerObj

        if (components != "") {
            this._components := components
        }

        if (autoLoad) {
            this.LoadComponents()
        }
    }

    LoadComponents() {
        if (!this._componentsLoaded) {
            components := ServiceComponentContainer(this._components)

            if (this._registerEvent) {
                event := RegisterComponentsEvent(this._registerEvent, components)
                this.eventManagerObj.DispatchEvent(this._registerEvent, event)
                components := event.container
            }

            if (this._alterEvent) {
                event := AlterComponentsEvent(this._alterEvent, components)
                this.eventManagerObj.DispatchEvent(this._alterEvent, event)
                components := event.container
            }

            this.components := components.Items
            this._componentsLoaded := true
        }
    }
    
    GetItem(key) {
        if (!this.HasItem(key)) {
            serviceName := this.__Class
            throw AppException(serviceName . " does not contain key " . key)
        }

        return this._components[key]
    }

    HasItem(key) {
        return this._components.Has(key)
    }

    GetAllItems() {
        return this._components
    }

    SetItem(key, item) {
        this._components[key] := item
        return this
    }

    RemoveItem(key) {
        if (this.HasItem(key)) {
            this._components.Delete(key)
        }

        return this
    }
}
