class EntityListEvent extends EventBase {
    _entityTypeId := ""
    _entityList := []
    _includeManaged := false
    _includeExtended := false

    __New(eventName, entityTypeId, entityList, includeManaged, includeExtended) {
        this._entityTypeId := entityTypeId
        this._entityList := entityList
        this._includeManaged := includeManaged
        this._includeExtended := includeExtended

        super.__New(eventName)
    }

    EntityTypeId {
        get => this._entityTypeId
    }

    EntityList {
        get => this._entityList
        set => this._entityList := value
    }

    IncludeManaged {
        get => this._includeManaged
    }

    IncludeExtended {
        get => this._includeExtended
    }
}
