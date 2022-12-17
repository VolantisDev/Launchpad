class EntityManagerBase extends ComponentManagerBase {
    storageObj := ""
    factoryObj := ""
    entityTypeId := ""
    childManagers := Map()

    __New(container, entityTypeId, eventMgr, notifierObj, storageObj, factoryObj, componentType, definitionLoaders := "", autoLoad := false) {
        this.storageObj := storageObj
        this.entityTypeId := entityTypeId
        this.factoryObj := factoryObj
        servicePrefix := this.GetServicePrefix()

        manager := container.Get("manager.entity_type")

        for , childTypeId in manager.GetChildEntityTypeIds(entityTypeId) {
            serviceName := "entity_manager." . childTypeId

            if (container.Has(serviceName)) {
                this.childManagers[childTypeId] := container.Get(serviceName)
            }
        }

        super.__New(container, servicePrefix, eventMgr, notifierObj, componentType, definitionLoaders, autoLoad)
    }

    static Create(entityTypeId, definition, container) {
        className := this.Prototype.__Class
        manager := container.Get("manager.entity_type")

        return %className%(
            container,
            entityTypeId,
            container.Get(definition["event_manager"]),
            container.Get(definition["notifier"]),
            manager.GetStorage(entityTypeId),
            manager.GetFactory(entityTypeId),
            definition["entity_class"],
            manager.GetDefinitionLoader(entityTypeId)
        )
    }

    GetFactory() {
        return this.factoryObj
    }

    GetStorage() {
        return this.storageObj
    }

    GetEntityTypeId() {
        return this.entityTypeId
    }

    GetServicePrefix() {
        return "entity." . this.entityTypeId . "."
    }

    SaveModifiedEntities(recurse := true) {
        for key, entityObj in this.All() {
            if (entityObj.IsModified(recurse)) {
                entityObj.SaveEntity(recurse)
            }
        }
    }

    RemoveEntity(key) {
        if (this.Has(key)) {
            entityObj := this[key]
            this.UnloadComponent(key, true)
            entityObj.DeleteEntity()
        }

        return this
    }

    AddEntity(key, entityObj) {
        this.SetComponent(key, Map("service", entityObj))
        entityObj.SaveEntity()
        return this
    }

    EntityQuery(resultType := "ids") {
        return EntityQuery(this, resultType)
    }

    normalizeComponentId(componentId) {
        return super.normalizeComponentId(componentId)
    }

    LoadComponents(reloadComponents := false) {
        super.LoadComponents(reloadComponents)

        for childEntityType, childManager in this.childManagers {
            childManager.LoadComponents(reloadComponents)
        }
    }

    /**
     * Get an array of all IDs
     * 
     * List managed IDs and give modules a chance to add others.
     */
    ListEntities(includeManaged := true, includeExtended := true) {
        entities := includeManaged
            ? this.EntityQuery(EntityQuery.RESULT_TYPE_IDS).Execute()
            : []

        if (includeExtended) {
            event := EntityListEvent(
                EntityEvents.ENTITY_LIST_ENTITIES, 
                this.entityTypeId, 
                entities, 
                includeManaged, 
                includeExtended
            )
            this.eventMgr.DispatchEvent(event)

            entities := event.EntityList
        }

        return entities
    }
}
