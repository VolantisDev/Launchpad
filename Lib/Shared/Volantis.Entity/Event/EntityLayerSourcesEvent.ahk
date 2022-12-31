class EntityLayerSourcesEvent extends EntityEvent {
    _layerSourcesObj := ""

    LayerSources {
        get => this._layerSourcesObj
    }

    __New(eventName, entityTypeId, entityObj, layerSourcesObj) {
        this._layerSourcesObj := layerSourcesObj

        super.__New(eventName, entityTypeId, entityObj)
    }
}
