class EntityReferenceEvent extends EntityEvent {
    _fieldId := ""
    _referenceTypeId := ""
    _referencedEntity := ""

    __New(eventName, entityTypeId, entityObj, fieldId, referenceTypeId, referencedEntity) {
        this._fieldId := fieldId
        this._referenceTypeId := referenceTypeId
        this._referencedEntity := referencedEntity

        super.__New(eventName, entityTypeId, entityObj)
    }

    FieldId {
        get => this._fieldId
    }

    ReferenceTypeId {
        get => this._referenceTypeId
    }

    ReferencedEntity {
        get => this._referencedEntity
    }
}
