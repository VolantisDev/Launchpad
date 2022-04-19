class EntityTypeBase {
    id := ""
    servicePrefix := ""
    entityManagerObj := ""
    storageObj := ""
    factoryObj := ""
    definition := ""
    
    __New(entityTypeId, servicePrefix, entityManagerObj, storageObj, factoryObj, entityTypeDefinition) {
        this.id := entityTypeId
        this.servicePrefix := servicePrefix
        this.entityManagerObj := entityManagerObj
        this.storageObj := storageObj
        this.factoryObj := factoryObj
        this.definition := entityTypeDefinition
    }

    static Create(entityTypeId, definition, container) {
        className := this.Prototype.__Class

        manager := container.Get("manager.entity_type")

        return %className%(
            entityTypeId,
            definition["service_prefix"],
            manager.GetManager(entityTypeId),
            manager.GetStorage(entityTypeId),
            manager.GetFactory(entityTypeId),
            definition
        )
    }

    GetId() {
        return this.id
    }

    GetServicePrefix() {
        return this.servicePrefix
    }

    GetEntityManager() {
        return this.entityManagerObj
    }

    GetStorage() {
        return this.storageObj
    }

    GetFactory() {
        return this.factoryObj
    }

    GetDefinition() {
        return this.definition
    }
}