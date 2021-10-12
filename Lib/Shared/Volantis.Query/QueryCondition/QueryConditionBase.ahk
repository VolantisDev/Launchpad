/*
    This class type is meant to be instantiated inside of a Query object automatically.
*/
class QueryConditionBase extends ConditionBase {
    key := ""
    data := ""

    __New(conditions, negate := false) {
        super.__New(conditions, negate)
    }

    evaluateChildCondition(condition, key, data, args*) {
        matches := false

        if (condition.HasBase(QueryConditionBase.Prototype)) {
            matches := super.evaluateChildCondition(condition, key, data, args*)
        } else {
            matches := super.evaluateChildCondition(condition, this.getQueryValue(key, data, args*))
        }
        
        return matches
    }

    getQueryValue(key, data, args*) {
        return ""
    }

    EvaluateCondition(key, data, args*) {
        return true
    }
}
