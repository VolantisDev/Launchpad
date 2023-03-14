class EntityFieldGroupsEvent extends EntityEvent {
    _fieldGroups := ""

    __New(eventName, entityTypeId, entityObj, fieldGroups) {
        this._fieldGroups := fieldGroups

        super.__New(eventName, entityTypeId, entityObj)
    }

    FieldGroups {
        get => this._fieldGroups
    }

    SetFieldGroup(key, definition) {
        this._fieldGroups[key] := definition
    }
}
