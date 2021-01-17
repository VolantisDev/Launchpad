class RegisterComponentsEvent extends EventBase {
    _items := Map()

    Items {
        get => this._items
    }

    __New(eventName, items := "") {
        if (items != "") {
            this._items := items
        }

        super.__New(eventName)
    }

    Register(key, componentObj) {
        this._items[key] := componentObj
    }
}
