class EntityFactory {
    container := ""
    storageObj := ""
    eventMgr := ""
    servicePrefix := ""
    entityTypeId := ""
    entityClass := ""
    idSanitizer := ""

    __New(container, storageObj, eventMgr, idSanitizer, servicePrefix, entityTypeId, entityClass) {
        this.container := container
        this.storageObj := storageObj
        this.eventMgr := eventMgr
        this.idSanitizer := idSanitizer
        this.servicePrefix := servicePrefix
        this.entityTypeId := entityTypeId
        this.entityClass := entityClass
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
            eventMgr,
            idSanitizer,
            definition["service_prefix"],
            entityTypeId,
            definition["entity_class"]
        )
    }

    DetectServiceDefinitions() {
        definitions := Map()

        for index, key in this.storageObj.DiscoverEntities() {
            definitions[key] := this.CreateServiceDefinition(key)
        }

        return definitions
    }

    /**
     * Creates a service definition to lazy-load an entity.
     */
    CreateServiceDefinition(id, data := "", parentEntity := "") {
        return Map(
            "factory", this,
            "method", "CreateEntity",
            "arguments", [id, data, parentEntity]
        )
    }

    CreateEntity(id, data := "", parentEntity := "") {
        entityTypeObj := this.entityClass

        if (data) {
            if (Type(data) == "String") {
                data := Map("class", data)
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
