class EntityReferenceField extends ServiceReferenceField {
    managerObj := ""

    DefinitionDefaults(fieldDefinition) {
        entityTypeId := fieldDefinition["entityType"]

        if (!entityTypeId) {
            throw EntityException("Entity reference fields require an entityType mapping.")
        }

        managerObj := this._entityManager(entityTypeId)
        defaults := super.DefinitionDefaults(fieldDefinition)

        defaults["servicePrefix"] := managerObj.GetServicePrefix()
        defaults["entityType"] := managerObj.entityTypeId
        defaults["child"] := false

        return defaults
    }

    GetValidators(value) {
        validators := super.GetValidators(value)

        if (value) {
            ; @todo check if entity exists
        }
        
        return validators
    }

    _entityManager(entityTypeId := "") {
        if (!this.managerObj) {
            if (!entityTypeId) {
                entityTypeId := this.Definition["entityType"]
            }

            this.managerObj := this.container.Get("entity_manager." . entityTypeId)
        }

        return this.managerObj
    }

    _getService(entityId) {
        if (!this.Definition["entityType"]) {
            throw AppException("Entity type of reference field is not specified")
        }

        entityObj := ""

        if (entityId && this._entityManager().Has(entityId)) {
            entityObj := this._entityManager()[entityId]
            entityObj.LoadEntity()
        }

        return entityObj
    }

    _getSelectQuery() {
        return this._entityManager().EntityQuery(EntityQuery.RESULT_TYPE_IDS)
    }
}
