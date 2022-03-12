class ContainerQuery extends QueryBase {
    container := ""
    servicePrefix := ""
    removePrefix := false

    static RESULT_TYPE_NAMES := "names"
    static RESULT_TYPE_DEFINITIONS := "definitions"
    static RESULT_TYPE_SERVICES := "services"

    __New(container, servicePrefix := "", resultType := "names", removePrefix := false) {
        this.container := container
        this.servicePrefix := servicePrefix
        this.removePrefix := removePrefix
        super.__New(resultType)
    }

    initializeResults() {
        if (this.resultType == ContainerQuery.RESULT_TYPE_NAMES) {
            this.results := []
        } else {
            this.results := Map()
        }
    }

    getStorageDefinitions() {
        definitions := this.container.Items

        if (this.servicePrefix) {
            filteredDefinitions := Map()

            for key, definition in definitions {
                if (SubStr(key, 1, StrLen(this.servicePrefix)) == this.servicePrefix) {
                    filteredDefinitions[key] := definition
                }
            }

            definitions := filteredDefinitions
        }

        return definitions
    }

    addResult(itemKey, itemDefinition) {
        fullItemKey := itemKey

        if (this.servicePrefix && this.removePrefix) {
            itemKey := SubStr(itemKey, StrLen(this.servicePrefix) + 1)
        }

        if (this.resultType == ContainerQuery.RESULT_TYPE_NAMES) {
            this.results.Push(itemKey)
        } else if (this.resultType == ContainerQuery.RESULT_TYPE_DEFINITIONS) {
            this.results[itemKey] := itemDefinition
        } else if (this.resultType == ContainerQuery.RESULT_TYPE_SERVICES) {
            this.results[itemKey] := this.container.Get(fullItemKey)
        } else {
            throw ContainerException("Container query has unknown result type " . this.resultType)
        }
    }
}
