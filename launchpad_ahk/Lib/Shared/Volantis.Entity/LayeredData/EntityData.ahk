class EntityData extends LayeredDataBase {
    entityTypeId := ""
    entity := ""
    eventMgr := ""

    __New(entity, layerNames := "", layerSources := "") {
        this.entityTypeId := entity.EntityTypeId
        this.entity := entity
        this.eventMgr := entity.eventMgr

        super.__New(
            entity.cloner, 
            this._createProcessors(),
            layerNames,
            layerSources
        )
    }

    InitializeLayers(layerNames) {
        if (!layerNames) {
            layerNames := []
        }

        this._appendLayerNames(["defaults"], layerNames)

        event := EntityLayersEvent(EntityEvents.ENTITY_DATA_LAYERS, this.entityTypeId, this.entity, layerNames)
        this.eventMgr.DispatchEvent(event)

        layerNames := event.Layers
        this._appendLayerNames(["auto", "data"], layerNames)

        event := EntityLayersEvent(EntityEvents.ENTITY_DATA_LAYERS_ALTER, this.entityTypeId, this.entity, layerNames)
        this.eventMgr.DispatchEvent(event)

        layerNames := event.Layers
        layers := Map()

        for index, layerName in layerNames {
            this.layerPriority.Push(layerName)
            layers[layerName] := Map()
        }

        this.SetLayers(layers)
    }

    SetLayerSources(layerSources) {
        if (!layerSources.Has("defaults")) {
            layerSources["defaults"] := ObjBindMethod(this.entity, "InitializeDefaults")
        }

        event := EntityLayerSourcesEvent(EntityEvents.ENTITY_LAYER_SOURCES, this.entityTypeId, this.entity, layerSources)
        this.eventMgr.DispatchEvent(event)

        event := EntityLayerSourcesEvent(EntityEvents.ENTITY_LAYER_SOURCES_ALTER, this.entityTypeId, this.entity, event.LayerSources)
        this.eventMgr.DispatchEvent(event)

        for key, source in event.LayerSources {
            this.SetLayerSource(key, source)
        }
    }

    _createProcessors() {
        processors := [
            StringSanitizer(),
            PlaceholderExpander(this)
        ]

        event := EntityDataProcessorsEvent(EntityEvents.ENTITY_DATA_PROCESSORS, this.entityTypeId, this.entity, processors)
        this.eventMgr.DispatchEvent(event)

        event := EntityDataProcessorsEvent(EntityEvents.ENTITY_DATA_PROCESSORS_ALTER, this.entityTypeId, this.entity, event.Processors)
        this.eventMgr.DispatchEvent(event)

        return event.Processors
    }

    _appendLayerNames(namesToAppend, existingNames) {
        for index, name in namesToAppend {
            exists := false

            for index, layerName in existingNames {
                if (name == layerName) {
                    exists := true
                    break
                }
            }

            if (!exists) {
                existingNames.Push(name)
            }
        }
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
}
