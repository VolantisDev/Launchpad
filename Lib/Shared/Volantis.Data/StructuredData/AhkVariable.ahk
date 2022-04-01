class AhkVariable extends StructuredDataBase {
    FromString(&src, args*) {
		throw MethodNotImplementedException("AhkVariable", "FromString")
    }

    ToString(obj := "", lvl := 1, args*) {
		if (obj == "" && lvl == 1) {
			obj := this.obj
		}

        return this.ConvertValueToCode(obj)
    }

	ConvertValueToCode(value) {
        if (HasBase(value, Map.Prototype)) {
            value := this.ConvertMapToCode(value)
        } else if (HasBase(value, Array.Prototype)) {
            value := this.ConvertArrayToCode(value)
        } else if (IsObject(value)) {
            value := this.ConvertObjectToCode(value)
        } else if (Type(value) == "String" && value != "true" && value != "false") {
            value := StrReplace(value, "`"", "```"")
            value := "`"" . value . "`""
        }
        
        return value
    }

	ConvertMapToCode(typeConfig) {
        code := "Map("
        empty := true

        for key, value in typeConfig {
            if (!empty) {
                code .= ", "
            }

            code .= this.ConvertValueToCode(key) . ", " . this.ConvertValueToCode(value)
            empty := false
        }

        code .= ")"

        return code
    }

    ConvertArrayToCode(typeConfig) {
        code := "["
        empty := true

        for index, value in typeConfig {
            if (!empty) {
                code .= ", "
            }

            code .= this.ConvertValueToCode(value)
            empty := false
        }

        code .= "]"

        return code
    }

    ConvertObjectToCode(typeConfig) {

        code := "{"
        empty := true

        for key, value in typeConfig {
            if (!empty) {
                code .= ", "
            }

            code .= key . ": " . this.ConvertValueToCode(value)
            empty := false
        }

        code .= "}"

        return code
    }
}
