class MapQuery extends QueryBase {
    getFieldCondition(condition, field, params*) {
        return FieldCondition(field, condition)
    }
}
