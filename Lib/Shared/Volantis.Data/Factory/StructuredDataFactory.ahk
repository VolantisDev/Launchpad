class StructuredDataFactory {
    types := Map()

    __New(types) {
        if (types) {
            for key, definition in types {
                this.types[key] := definition
            }
        }
    }

    Create(sdType, obj := "") {
        if (!this.types.Has(sdType)) {
            throw DataException("Structured Data type " . sdType . " does not exist")
        }

        className := this.types[sdType]["class"]

        if (!HasMethod(%className%)) {
            throw DataException("Structured data type " . sdType . " has invalid class: " . className)
        }

        return %className%(obj)
    }

    FromFile(filename) {
        sdType := ""

        for checkType, definition in this.types {
            if (definition.Has("extensions") && definition["extensions"]) {
                for index, ext in definition["extensions"] {
                    if (SubStr(filename, -StrLen(ext)) == ext) {
                        sdType := checkType
                        break
                    }
                }
            }
        }

        if (!sdType) {
            throw DataException("Could not find a Structured Data type to handle filename: " . filename)
        }

        sdObj := this.Create(sdType)
        sdObj.FromFile(filename)
        return sdObj
    }
}
