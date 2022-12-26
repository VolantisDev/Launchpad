class EntityReferenceField extends EntityFieldBase {
    managerObj := ""

    DefinitionDefaults(fieldDefinition) {
        entityTypeId := fieldDefinition["entityType"]

        if (!entityTypeId) {
            throw EntityException("Entity reference fields require an entityType mapping.")
        }

        defaults := super.DefinitionDefaults(fieldDefinition)

        defaults["entityType"] := entityTypeId
        defaults["widget"] := "select"
        defaults["child"] := false
        defaults["storeEntityData"] := false
        defaults["selectOptionsCallback"] := ObjBindMethod(this, "GetEntitySelectOptions")
        defaults["selectConditions"] := []

        return defaults
    }

    GetValidators(value) {
        validators := super.GetValidators(value)

        if (value) {
            ; @todo check if entity exists

            if (this.Definition["child"]) {
                ; @todo Add validator for child entity
            }
        }
        
        return validators
    }

    GetValue(index := "") {
        value := super.GetValue(index)

        if (!HasBase(value, Array.Prototype)) {
            value := [value]
        }

        entities := []
        entityManager := this._entityManager()

        for entityIndex, entityId in value {
            if (!entityId) {
                entities.Push("")
            } else if (entityManager.Has(entityId)) {
                entities.Push(entityManager[entityId])
            } else {
                throw AppException("Entity with ID '" . entityId . "' does not exist.")
            }
        }

        if (!this.multiple || index) {
            value := entities.Length ? entities[1] : ""
        } else {
            value := entities
        }

        return value
    }

    SetValue(value, index := "") {
        if (!HasBase(value, Array.Prototype)) {
            value := [value]
        }

        newValues := []

        for singleIndex, singleValue in value {
            if (HasBase(singleValue, EntityBase.Prototype)) {
                newValues.Push(singleValue.Id)
            } else if (Type(singleValue) == "String") {
                newValues.Push(singleValue)
            } else {
                throw AppException("Invalid entity reference data.")
            }
        }

        value := newValues

        if (!this.multiple || index) {
            value := value.Length ? value[1] : ""
        }

        super.SetValue(value, index)
        return this
    }

    GetEntitySelectOptions() {
        options := this._getSelectQuery().Execute()

        if (!this.Definition["required"]) {
            options.InsertAt(1, "")
        }

        return options
    }

    _entityManager(entityTypeId := "") {
        if (!this.managerObj) {
            if (!entityTypeId) {
                entityTypeId := this.Definition["entityType"]
            }

            this.managerObj := this.container["entity_manager." . entityTypeId]
        }

        return this.managerObj
    }

    _getSelectQuery() {
        query := this._entityManager().EntityQuery(EntityQuery.RESULT_TYPE_IDS)
        conditions := this.Definition["selectConditions"]

        if (conditions) {
            if (Type(conditions) != "Array") {
                conditions := [conditions]
            }

            for index, condition in conditions {
                query.Condition(condition)
            }
        }

        return query
    }
}
