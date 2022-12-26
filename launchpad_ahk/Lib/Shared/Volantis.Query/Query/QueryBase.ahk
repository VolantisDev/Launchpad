class QueryBase {
    resultType := ""
    conditions := []
    results := ""
    executed := false

    __New(resultType := "") {
        this.resultType := resultType
    }

    SetResultType(resultType) {
        this.resultType := resultType
    }

    Condition(condition, field := "", params*) {
        if (!condition.HasBase(ConditionBase.Prototype)) {
            throw QueryException("Provided condition is not of correct type. Provided type was: " . Type(condition))
        }

        condition := this.preprocessCondition(condition, field, params*)

        if (condition) {
            this.conditions.Push(condition)
        }
        
        return this
    }

    preprocessCondition(condition, field := "", params*) {
        if (!condition.HasBase(QueryConditionBase.Prototype)) {
            if (field) {
                if (field == "{}") {
                    field := ""
                }

                condition := this.getFieldCondition(condition, field, params*)
            } else {
                condition := this.getIdCondition(condition, params*)
            }
        }

        return condition
    }

    getIdCondition(condition, params*) {
        return IdCondition(condition)
    }

    getFieldCondition(condition, field, params*) {
        return FieldCondition(condition, field)
    }

    Matches(pattern, field := "", params*) {
        return this.Condition(MatchesCondition(pattern), field, params*)
    }

    RegEx(pattern, field := "", params*) {
        return this.Condition(RegExCondition(pattern), field, params*)
    }

    StartsWith(pattern, field := "", params*) {
        return this.Condition(StartsWithCondition(pattern), field, params*)
    }

    EndsWith(pattern, field := "", params*) {
        return this.Condition(EndsWithCondition(pattern), field, params*)
    }

    Contains(pattern, field := "", params*) {
        return this.Condition(ContainsCondition(pattern), field, params*)
    }

    Execute() {
        this.initializeResults()

        for key, definition in this.getStorageDefinitions() {
            if (this.matchesQuery(key, definition)) {
                this.addResult(key, definition)
            }
        }

        this.executed := true
        return this.GetResults()
    }

    GetResults() {
        return this.results
    }

    initializeResults() {
        this.results := []
    }

    getStorageDefinitions() {

    }

    matchesQuery(itemKey, itemDefinition) {
        matches := this.conditions.Length == 0 ? true : false

        for index, condition in this.conditions {
            matches := condition.Evaluate(itemKey, itemDefinition)

            if (!matches) {
                break
            }
        }

        return matches
    }

    addResult(itemKey, itemDefinition) {
        this.results.Push(itemKey)
    }
}
