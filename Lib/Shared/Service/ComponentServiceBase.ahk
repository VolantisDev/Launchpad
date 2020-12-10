class ComponentServiceBase extends ServiceBase {
    _components := Map()
    
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
