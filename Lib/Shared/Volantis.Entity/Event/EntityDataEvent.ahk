class EntityDataEvent extends EntityEvent {
    _entityData := ""

    EntityData {
        get => this._entityData
    }

    __New(eventName, entityTypeId, entityObj, entityData) {
        this._entityData := entityData

        super.__New(eventName, entityTypeId, entityObj)
    }
}
