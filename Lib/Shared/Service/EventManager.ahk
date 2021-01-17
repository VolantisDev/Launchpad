class EventManager extends ServiceBase {
    _handlers := Map()
    _bindMethod := ""

    __New() {
        this._bindMethod := ObjBindMethod(this, "HandleEvent")
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
        if (this._handlers.Has(eventName) && this._handlers[eventName].Has(key)) {
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

    DispatchEvent(eventName, eventObj, extra := "", hwnd := "") {
        if (hwnd == "") {
            hwnd := A_ScriptHwnd
        }

        return this.HandleEvent(eventObj, extra, eventName, hwnd)
    }

    HandleEvent(param1, param2, eventName, hwnd := "") {
        if (this._handlers.Has(eventName) && this._handlers[eventName].Count > 0) {
            for key, eventHandler in this._handlers[eventName] {
                %eventHandler%(param1, param2, eventName, hwnd)
            }
        }
    }
}
