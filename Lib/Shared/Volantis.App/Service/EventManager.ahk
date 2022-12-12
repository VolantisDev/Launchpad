class EventManager {
    _handlers := Map()
    _priorities := Map()
    _bindMethod := ""
    _registeredServices := Map()

    __New() {
        this._bindMethod := ObjBindMethod(this, "HandleEvent")
    }

    RegisterServiceSubscribers(container, servicePrefix := "") {
        services := container.Query(servicePrefix)
            .Condition(HasServiceTagsCondition("event_subscriber"))
            .Execute()
        
        for key, service in services {
            if (this._registeredServices.Has(key) && this._registeredServices[key]) {
                ; Ensure the method is idempotent by only registering new services
                continue
            }

            subscribers := []

            if (!HasMethod(service, "GetEventSubscribers")) {
                throw AppException("Service " . key . " is an event subscriber but is lacking a GetEventSubscribers method")
            }

            subscribers := service.GetEventSubscribers()

            if (subscribers) {
                for eventName, eventSubscribers in subscribers {
                    if (eventSubscribers) {
                        if (Type(eventSubscribers) == "String") {
                            eventSubscribers := [eventSubscribers]
                        }

                        for index, subscriber in eventSubscribers {
                            eventId := key . "-" . eventName . "-" . index

                            if (!this.HasSubscriber(eventName, eventId)) {
                                this.Register(eventName, eventId, subscriber)
                            }
                        }
                    }
                }
            }

            this._registeredServices[key] := true
        }
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

    DispatchEvent(eventObj, extra := "", hwnd := "") {
        if (hwnd == "") {
            hwnd := A_ScriptHwnd
        }

        if (!eventObj.EventName) {
            throw AppException("Event object does not have an event name.")
        }

        return this.HandleEvent(eventObj, extra, eventObj.EventName, hwnd)
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
