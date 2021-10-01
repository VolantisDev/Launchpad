class DataProcessorBase {
    Process(value) {
        if (this.AppliesTo(value)) {
            if (Type(value) == "String") {
                value := this.ProcessSingleValue(value)
            } else if (Type(value) == "Array" || Type(value) == "Map") {
                for key, arrayVal in value {
                    value[key] := this.Process(arrayVal)
                }
            }
        }

        return value
    }

    ProcessSingleValue(value) {
        throw MethodNotImplementedException("DataProcessorBase", "Process")
    }

    AppliesTo(value) {
        objType := Type(value)
        return (objType == "String" || objType == "Map" || objType == "Array")
    }
}
