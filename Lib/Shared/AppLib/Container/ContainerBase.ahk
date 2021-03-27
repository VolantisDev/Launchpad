class ContainerBase {
    itemsObj := Map()

    Items {
        get => this.itemsObj
    }

    __New(items := "") {
        if (items) {
            this.itemsObj := items
        }
    }

    Get(key) {
        result := ""

        if (this.Items.Has(key)) {
            result := this.DereferenceValue(this.Items[key])
        }

        return result
    }

    Exists(key) {
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
            return this.DereferenceItem(key)
        } else {
            return value
        }
    }
}
