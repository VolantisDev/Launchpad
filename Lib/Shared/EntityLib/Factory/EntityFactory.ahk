class EntityFactory {
    container := ""

    __New(container) {
        this.container := container
    }

    CreateEntity(entityType, key, configObj, parentEntity := "", requiredConfigKeys := "") {
        if (!%entityType%.HasMethod("CreateEntity")) {
            throw EntityException("Unable to create entity '" . key . "' of type '" . entityType . "' in EntityFactory")
        }

        return %entityType%.CreateEntity(this.container, key, configObj, parentEntity, requiredConfigKeys)
    }
}
