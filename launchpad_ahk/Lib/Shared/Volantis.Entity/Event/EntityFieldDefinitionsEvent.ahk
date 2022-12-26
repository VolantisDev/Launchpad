class EntityFieldDefinitionsEvent extends EntityEvent {
    _fieldDefinitions := ""

    __New(eventName, entityTypeId, entityObj, fieldDefinitions) {
        this._fieldDefinitions := fieldDefinitions

        super.__New(eventName, entityTypeId, entityObj)
    }

    FieldDefinitions {
        get => this._fieldDefinitions
    }

    SetFieldDefinition(key, definition) {
        this._fieldDefinitions[key] := definition
    }
}
