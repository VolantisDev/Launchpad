class EntityDetectValuesEvent extends EntityEvent {
    _valuesMap := ""

    Values {
        get => this._valuesMap
    }

    __New(eventName, entityTypeId, entityObj, values := "") {
        if (!values) {
            values := Map()
        }

        this._valuesMap := values

        super.__New(eventName, entityTypeId, entityObj)
    }
}
