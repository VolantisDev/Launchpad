class EntityFactory {
    container := ""

    __New(container) {
        this.container := container
    }

    ; TODO: Support loading entity configuration from a storage service
    CreateEntity(entityType, key, configObj, parentEntity := "", requiredConfigKeys := "") {
        if (parentEntity && !parentEntity.HasBase(EntityBase)) {
            throw AppException("Provided parent entity must be an Entity object, but this factory was provided the following: " . Type(parentEntity))
        }
    
        if (!%entityType%.HasMethod("CreateEntity")) {
            throw EntityException("Unable to create entity '" . key . "' of type '" . entityType . "' in EntityFactory")
        }

        return %entityType%.CreateEntity(this.container, key, configObj, parentEntity, requiredConfigKeys)
    }
}
