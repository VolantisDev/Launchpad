class EntityEvent extends EventBase {
    _entityTypeId := ""
    _entity := ""

    __New(eventName, entityTypeId, entityObj) {
        this._entityTypeId := entityTypeId
        this._entity := entityObj

        super.__New(eventName)
    }

    EntityTypeId {
        get => this._entityTypeId
    }

    Entity {
        get => this._entity
    }
}
