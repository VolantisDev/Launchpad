class EventManager extends ServiceBase {
    _handlers := Map()
    _bindMethod := ""

    __New() {
        this._bindMethod := ObjBindMethod(this, "DispatchEvent")
    }

    Register(eventName, key, eventHandler) {
        start := false

        if (!this._handlers.Has(eventName)) {
            this._handlers[eventName] := Map()
            start := true
        }

        this._handlers[eventName][key] := eventHandler
        return start ? this.StartListener(eventName) : this
    }

    Unregister(eventName, key) {
        if (this._handlers.Has(eventName) and this._handlers[eventName].Has(key)) {
            this._handlers[eventName].Delete(key)

            if (this._handlers[eventName].Count == 0) {
                this.StopListener(eventName)
            }
        }

        return this
    }

    StartListener(eventName) {
        OnMessage(eventName, this._bindMethod)
        return this
    }

    StopListener(eventName) {
        OnMessage(eventName, this._bindMethod, 0)
        return this
    }

    DispatchEvent(wParam, lParam, msg, hwnd) {
        if (this._handlers.Has(msg) and this._handlers[msg].Count > 0) {
            for key, eventHandler in this._handlers[msg] {
                %eventHandler%(wParam, lParam, msg, hwnd)
            }
        }
    }
}
