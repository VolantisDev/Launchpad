class EntityFactory {
    container := ""
    storageObj := ""
    mergerObj := ""
    eventMgr := ""
    servicePrefix := ""
    entityTypeId := ""
    entityClass := ""
    idSanitizer := ""
    definition := ""

    __New(container, storageObj, mergerObj, eventMgr, idSanitizer, servicePrefix, entityTypeId, entityClass, definition) {
        this.container := container
        this.storageObj := storageObj
        this.mergerObj := mergerObj
        this.eventMgr := eventMgr
        this.idSanitizer := idSanitizer
        this.servicePrefix := servicePrefix
        this.entityTypeId := entityTypeId
        this.entityClass := entityClass
        this.definition := definition
    }

    static Create(entityTypeId, definition, container) {
        className := this.Prototype.__Class

        sanitizer := definition["id_sanitizer"]

        if (Type(sanitizer) == "String") {
            sanitizer := container.Get(sanitizer)
        }

        eventMgr := definition["event_manager"]

        if (Type(eventMgr) == "String") {
            eventMgr := container.Get(eventMgr)
        }

        idSanitizer := definition["id_sanitizer"]

        if (Type(idSanitizer) == "String") {
            idSanitizer := container.Get(idSanitizer)
        }

        return %className%(
            container,
            container.Get("manager.entity_type").GetStorage(entityTypeId),
            container.Get("merger.list"),
            eventMgr,
            idSanitizer,
            definition["service_prefix"],
            entityTypeId,
            definition["entity_class"],
            definition
        )
    }

    DetectServiceDefinitions() {
        definitions := Map()

        for index, key in this.storageObj.DiscoverEntities() {
            definitions[key] := this.CreateServiceDefinition(key)
        }

        if (this.definition["definition_loader_parameter_key"]) {
            param := this.container.GetParameter(this.definition["definition_loader_parameter_key"])

            if (HasBase(param, Map.Prototype)) {
                for key, data in param {
                    definitions[key] := this.CreateServiceDefinition(key, data, "", true)
                }
            }
        }

        return definitions
    }

    /**
     * Creates a service definition to lazy-load an entity.
     */
    CreateServiceDefinition(id, data := "", parentEntity := "", mergeData := false) {
        return Map(
            "factory", this,
            "method", "CreateEntity",
            "arguments", [id, data, parentEntity, mergeData]
        )
    }

    CreateEntity(id, data := "", parentEntity := "", mergeData := false) {
        entityTypeObj := this.entityClass

        if (data) {
            if (Type(data) == "String") {
                data := Map("class", data)
            }

            if (mergeData) {
                storageData := this.storageObj.HasData(id) ? this.storageObj.LoadData(id) : Map()
                this.mergerObj.Merge(data, storageData)
            }

            this.storageObj.SaveData(id, data)

            if (data.Has("class") && data["class"]) {
                entityTypeObj := data["class"]
            }
        }

        if (!%entityTypeObj%.HasMethod("Create")) {
            throw EntityException("Unable to create entity '" . id . "' of type '" . entityTypeObj . "' in EntityFactory")
        }

        return %entityTypeObj%.Create(this.container, this.eventMgr, id, this.entityTypeId, this.storageObj, this.idSanitizer, parentEntity)
    }
}
