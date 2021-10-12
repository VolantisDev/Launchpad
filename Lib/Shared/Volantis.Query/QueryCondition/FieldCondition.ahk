class FieldCondition extends QueryConditionBase {
    field := ""

    __New(conditions, field := "", negate := false) {
        this.field := field
        super.__New(conditions, negate)
    }

    getQueryValue(key, data, args*) {
        context := data

        if (this.field) {
            tokens := StrSplit(this.field, ".")

            for index, token in tokens {
                if (!context.Has(token)) {
                    throw ContainerException("Object does not have field: " . this.field)
                }

                context := context[token]
            }
        }

        return context
    }
}
