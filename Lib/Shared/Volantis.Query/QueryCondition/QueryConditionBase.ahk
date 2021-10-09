/*
    This class type is meant to be instantiated inside of a Query object automatically.
*/
class QueryConditionBase extends ConditionBase {
    key := ""
    data := ""

    __New(conditions, negate := false) {
        super.__New(conditions, negate)
    }

    evaluateChildConditions(key, data, args*) {
        super.evaluateChildConditions([this.getQueryValue(key, data, args*)])
    }

    getQueryValue(key, data, args*) {

    }

    EvaluateCondition(key, data, args*) {
        return true
    }
}
