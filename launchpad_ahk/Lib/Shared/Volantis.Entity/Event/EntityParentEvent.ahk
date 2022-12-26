class EntityParentEvent extends EntityEvent {
    _parentEntity := ""
    _parentEntityTypeId := ""
    _parentEntityId := ""

    __New(eventName, entityTypeId, entityObj, parentEntity := "", parentEntityTypeId := "", parentEntityId := "") {
        this._parentEntity := parentEntity
        this._parentEntityTypeId := parentEntityTypeId
        this._parentEntityId := parentEntityId

        super.__New(eventName, entityTypeId, entityObj)
    }

    ParentEntity {
        get => this._parentEntity
        set => this._parentEntity := value
    }

    ParentEntityTypeId {
        get => this._parentEntityTypeId
        set => this._parentEntityTypeId := value
    }
    
    ParentEntityId {
        get => this._parentEntityId
        set => this._parentEntityId := value
    }
}
