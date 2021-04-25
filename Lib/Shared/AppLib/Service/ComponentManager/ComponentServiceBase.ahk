class ComponentServiceBase extends ServiceBase {
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

        super.__New()

        if (autoLoad) {
            this.LoadComponents()
        }
    }

    LoadComponents() {
        if (!this._componentsLoaded) {
            components := this._components

            if (this._registerEvent) {
                event := RegisterComponentsEvent(this._registerEvent, components)
                this.eventManagerObj.DispatchEvent(this._registerEvent, event)
                components := event.Items
            }

            if (this._alterEvent) {
                event := AlterComponentsEvent(this._alterEvent, components)
                this.eventManagerObj.DispatchEvent(this._alterEvent, event)
                components := event.Items
            }

            this.components := components
            this._componentsLoaded := true
        }
    }
    
    GetItem(key) {
        component := ""

        if (this._components.Has(key)) {
            component := this._components[key]
        }

        return component
    }

    GetAllItems() {
        return this._components
    }

    SetItem(key, item) {
        this._components[key] := item
        return this
    }

    RemoveItem(key) {
        if (this._components.Has(key)) {
            this._components.Delete(key)
        }

        return this
    }
}
