class EntityValidateEvent extends EntityEvent {
    _validateResult := ""

    ValidateResult {
        get => this._validateResult
    }

    __New(eventName, entityTypeId, entityObj, validateResult) {
        this._validateResult := validateResult

        super.__New(eventName, entityTypeId, entityObj)
    }
}
