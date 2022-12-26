class HasServiceTagsCondition extends QueryConditionBase {
    field := "tags"

    __New(tags, negate := false) {
        conditions := [HasFieldCondition(this.field, "Array")]

        if (Type(tags) == "String") {
            tags := [tags]
        }

        for index, tag in tags {
            conditions.Push(FieldCondition(ContainsCondition(tag), this.field))
        }

        super.__New(conditions, negate)
    }

    getQueryValue(key, data, args*) {
        return data.Has(this.field) ? data[this.field] : []
    }
}
