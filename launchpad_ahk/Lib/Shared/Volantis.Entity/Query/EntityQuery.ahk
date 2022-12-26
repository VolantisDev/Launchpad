class EntityQuery extends QueryBase {
    entityManagerObj := ""

    static RESULT_TYPE_IDS := "ids"
    static RESULT_TYPE_ENTITIES := "services"
    static RESULT_TYPE_NAMES := "names"
    
    __New(entityManagerObj, resultType := "ids") {
        this.entityManagerObj := entityManagerObj
        super.__New(resultType)
    }

    initializeResults() {
        this.results := (this.resultType == EntityQuery.RESULT_TYPE_IDS) ? [] : Map()
    }

    getStorageDefinitions() {
        ; @TODO somehow query entity data (with defaults and external data) 
        ; without actually loading all entities
        return this.entityManagerObj.All()
    }

    addResult(itemKey, itemDefinition) {
        if (this.resultType == EntityQuery.RESULT_TYPE_IDS) {
            this.results.Push(itemKey)
        } else if (this.resultType == EntityQuery.RESULT_TYPE_NAMES) {
            entityObj := this.entityManagerObj[itemKey]
            this.results[itemKey] := entityObj["name"]
        } else if (this.resultType == EntityQuery.RESULT_TYPE_ENTITIES) {
            this.results[itemKey] := this.entityManagerObj[itemKey]
        } else {
            throw AppException("Query has unknown result type " . this.resultType)
        }
    }
}
