class EntityLayersEvent extends EntityEvent {
    _layers := []

    Layers {
        get => this._layers
    }

    __New(eventName, entityTypeId, entityObj, layers := "") {
        if (!layers) {
            layers := []
        }

        this._layers := layers

        super.__New(eventName, entityTypeId, entityObj)
    }
}
