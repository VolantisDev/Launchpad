class FieldCondition extends QueryConditionBase {
    field := ""
    allowMissing := false
    defaultValue := ""

    __New(conditions, field := "", negate := false, allowMissing := false, defaultValue := "") {
        this.field := field
        this.allowMissing := allowMissing
        this.defaultValue := defaultValue
        super.__New(conditions, negate)
    }

    getQueryValue(key, data, args*) {
        context := data

        if (this.field) {
            tokens := StrSplit(this.field, ".")

            for index, token in tokens {
                found := false

                if (HasBase(context, FieldableEntity.Prototype)) {
                    if (context.HasField(token)) {
                        context := context[token]
                        found := true
                    }
                } else if (context.Has(token)) {
                    context := context[token]
                    found := true
                }

                if (!found) {
                    if (this.allowMissing) {
                        context := this.defaultValue
                    } else {
                        throw ContainerException("Object does not have field: " . this.field)
                    }
                }
            }
        }

        return context
    }
}
