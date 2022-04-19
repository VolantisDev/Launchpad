class DataContext {
    dataObj := ""

    __Item[key] {
        get => this.Get(key)
        set => this.Set(key, value)
    }

    __Enum(NumberOfVars) {
        return this.dataObj.__Enum(NumberOfVars)
    }

    __New(data := "") {
        if (!data) {
            data := Map()
        }

        this.dataObj := data
    }

    Get(key := "") {
        if (!key) {
            return this.dataObj
        }

        if (this.dataObj.Has(key)) {
            return this.dataObj[key]
        } else {
            throw ContainerException("Undefined context key " . key)
        }
    }

    Set(key, value) {
        this.dataObj[key] := value
    }

    Remove(key) {
        if (this.dataObj.Has(key)) {
            this.dataObj.Delete(key)
        }
    }

    Has(key) {
        return this.dataObj.Has(key)
    }
}
