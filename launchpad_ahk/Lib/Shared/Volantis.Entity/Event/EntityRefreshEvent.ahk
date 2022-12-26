class EntityRefreshEvent extends EntityEvent {
    _recurse := false

    Recurse {
        get => this._entityData
    }

    __New(eventName, entityTypeId, entityObj, recurse := false) {
        this._recurse := recurse
        super.__New(eventName, entityTypeId, entityObj)
    }
}
