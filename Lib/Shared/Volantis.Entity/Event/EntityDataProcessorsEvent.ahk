class EntityDataProcessorsEvent extends EntityEvent {
    _entityDataProcessors := ""

    Processors {
        get => this._entityDataProcessors
    }

    __New(eventName, entityTypeId, entityObj, entityDataProcessors) {
        this._entityDataProcessors := entityDataProcessors

        super.__New(eventName, entityTypeId, entityObj)
    }
}
