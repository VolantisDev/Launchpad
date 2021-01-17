class AlterComponentsEvent extends EventBase {
    _items := Map()

    Items {
        get => this._items
        set => this._items := value
    }

    __New(eventName, items := "") {
        if (items != "") {
            this._items := items
        }

        super.__New(eventName)
    }
}
