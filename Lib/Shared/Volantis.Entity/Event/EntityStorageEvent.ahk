class EntityStorageEvent extends EntityEvent {
    _storageObj := ""

    Storage {
        get => this._storageObj
    }

    __New(eventName, entityTypeId, entityObj, storageObj) {
        this._storageObj := storageObj

        super.__New(eventName, entityTypeId, entityObj)
    }
}
