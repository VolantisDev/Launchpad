class EntityData extends LayeredDataBase {
    entityTypeId := ""
    entity := ""
    eventMgr := ""

    __New(entityTypeId, entity, layerSources) {
        this.entityTypeId := entityTypeId
        this.entity := entity
        this.eventMgr := entity.eventMgr

        if (!HasBase(layerSources, Map.Prototype)) {
            layerSources := Map("data", layerSources)
        }

        this.SetLayerSources(this.collectEntityStorage(layerSources))

        layers := this.InitializeLayerArray(this._getLayerNames(entityTypeId, entity))
        processors := this._createProcessors(entityTypeId, entity)

        super.__New(entity.cloner, processors, layers*)

        this.SetLayer("defaults", entity.InitializeDefaults())
    }

    collectEntityStorage(layerSources) {
        event := EntityStorageEvent(EntityEvents.ENTITY_STORAGE_OBJECTS, this.entityTypeId, this.entity, layerSources)
        this.eventMgr.DispatchEvent(event)

        event := EntityStorageEvent(EntityEvents.ENTITY_STORAGE_OBJECTS_ALTER, this.entityTypeId, this.entity, event.Storage)
        this.eventMgr.DispatchEvent(event)

        return event.Storage
    }

    _createProcessors(entityTypeId, entity) {
        processors := [
            StringSanitizer(),
            PlaceholderExpander(this)
        ]

        event := EntityDataProcessorsEvent(EntityEvents.ENTITY_DATA_PROCESSORS, entityTypeId, entity, processors)
        this.eventMgr.DispatchEvent(event)

        event := EntityDataProcessorsEvent(EntityEvents.ENTITY_DATA_PROCESSORS_ALTER, entityTypeId, entity, event.Processors)
        this.eventMgr.DispatchEvent(event)

        return event.Processors
    }

    _getLayerNames(entityTypeId, entity) {
        layers := ["defaults"]

        event := EntityLayersEvent(EntityEvents.ENTITY_DATA_LAYERS, entityTypeId, entity, layers)
        this.eventMgr.DispatchEvent(event)

        event.Layers.Push("auto", "data")

        event := EntityLayersEvent(EntityEvents.ENTITY_DATA_LAYERS_ALTER, entityTypeId, entity, event.Layers)
        this.eventMgr.DispatchEvent(event)

        return event.Layers
    }

    loadLayerFromSource(layer, sourceObj, cloneMap := true) {
        if (HasBase(sourceObj, EntityStorageBase.Prototype)) {
            storageId := this.entity.GetStorageId()

            sourceObj := sourceObj.HasData(storageId) 
                ? sourceObj.LoadData(storageId) 
                : ""
            cloneMap := false
        }

        super.loadLayerFromSource(layer, sourceObj, cloneMap)
    }

    SaveData() {
        storageId := this.entity.GetStorageId()

        for index, layer in this.userLayers {
            if (this.layerSources.Has(layer)) {
                layerSource := this.layerSources[layer]

                if (HasBase(layerSource, EntityStorageBase.Prototype)) {
                    layerSource.SaveData(storageId, this.GetLayer(layer))
                }
            }
        }
    }
}
