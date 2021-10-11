class EventManager {
    _handlers := Map()
    _priorities := Map()
    _bindMethod := ""

    __New() {
        this._bindMethod := ObjBindMethod(this, "HandleEvent")
    }

    Register(eventName, key, eventHandler, priority := 5) {
        start := false

        if (!this._handlers.Has(eventName)) {
            this._handlers[eventName] := Map()
            start := true
        }

        if (!this._priorities.Has(eventName)) {
            this._priorities[eventName] := [[], [], [], [], [], [], [], [], []]
        }

        this._handlers[eventName][key] := eventHandler
        this.SetPriority(eventName, key, priority)
        return start ? this.StartListener(eventName) : this
    }

    SetPriority(eventName, key, priority := 5) {
        this.RemovePriority(eventName, key)
        this._priorities[eventName][priority].Push(key)
    }

    GetPriority(eventName, key) {
        priority := ""

        if (this._priorities.Has(eventName)) {
            for index, keys in this._priorities[eventName] {
                for priorityIndex, priorityKey in keys {
                    if (key == priorityKey) {
                        priority := index
                        break
                    }
                }
            }
        }

        return priority
    }

    RemovePriority(eventName, key) {
        priority := this.GetPriority(eventName, key)

        if (priority) {
            for index, priorityKey in this._priorities[eventName][priority] {
                if (key == priorityKey) {
                    this._priorities[eventName][priority].RemoveAt(index)
                    break
                }
            }
        }
    }

    Unregister(eventName, key) {
        if (this.HasSubscriber(eventName, key)) {
            this._handlers[eventName].Delete(key)
            this.RemovePriority(eventName, key)

            if (this._handlers[eventName].Count == 0) {
                this.StopListener(eventName)
            }
        }

        return this
    }

    HasSubscriber(eventName, key) {
        return this._handlers.Has(eventName) && this._handlers[eventName].Has(key)
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
            for index, keys in this._priorities[eventName] {
                for priorityIndex, key in keys {
                    eventHandler := this._handlers[eventName][key]

                    if (eventHandler) {
                        this._handlers[eventName][key](param1, param2, eventName, hwnd)
                    }
                }
            }
        }
    }
}
