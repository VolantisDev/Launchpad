class DataProcessorBase {
    Process(value) {
        if (this.AppliesTo(value)) {
            if (Type(value) == "String") {
                value := this.ProcessSingleValue(value)
            } else if (HasBase(value, Array.Prototype) || HasBase(value, Map.Prototype)) {
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
        return (
            Type(value) == "String" 
            || HasBase(value, Map.Prototype) 
            || HasBase(value, Array.Prototype)
        )
    }
}
