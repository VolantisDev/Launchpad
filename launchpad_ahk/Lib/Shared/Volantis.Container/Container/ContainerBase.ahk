class ContainerBase {
    itemsObj := Map()

    __Item[name] {
        get => this.Get(name)
        set => this.Set(name, value)
    }

    Items {
        get => this.itemsObj
    }

    __Enum(numberOfVars) {
        return this.Items.__Enum(numberOfVars)
    }

    __New(items := "") {
        if (items) {
            this.itemsObj := items
        }
    }

    Get(key) {
        result := ""

        if (this.Items.Has(key)) {
            result := this.Items[key]

            if (Type(result) == "String") {
                result := this.DereferenceValue(result)
            }
        }

        return result
    }

    Has(key) {
        return !!(this.Items.Has(key) && this.Items[key])
    }

    Set(key, value) {
        this.Items[key] := value
    }

    Delete(key) {
        if (this.Items.Has(key)) {
            this.Items.Delete(key)
        }
    }

    DereferenceValue(value) {
        if (SubStr(value, 1, 2) == "{{") {
            key := SubStr(value, 3)
            key := SubStr(key, 1, -2)
            return this.DereferenceValue(key)
        } else {
            return value
        }
    }
}
