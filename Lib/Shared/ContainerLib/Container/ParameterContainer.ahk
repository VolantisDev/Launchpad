class ParameterContainer extends ContainerBase {
    parametersObj := Map()

    Parameters {
        get => this.parametersObj
    }
    
    __New(definitionLoader := "") {
        super.__New()

        if (definitionLoader) {
            this.LoadDefinitions(definitionLoader)
        }
    }

    LoadDefinitions(definitionLoader, replace := true) {
        parameters := definitionLoader.LoadParameterDefinitions()

        if (parameters) {
            for paramName, paramConfig in parameters {
                if (!this.Parameters.Has(paramName) || replace) {
                    this.SetParameter(paramName, paramConfig)
                }
            }
        }
    }

    LoadFromStructuredData(structuredData, servicesKey := "", parametersKey := "") {
        this.LoadDefinitions(StructuredDataDefinitionLoader(structuredData, "", servicesKey, parametersKey))
    }

    LoadFromMap(obj, servicesKey := "", parametersKey := "") {
        if (Type(obj) == "ParameterRef" || obj.HasBase(ParameterRef)) {
            obj := this.GetParameter(obj.GetName())
        }

        newObj := Map(
            "services", obj.Has("services") ? obj["services"] : Map(),
            "parameters", obj.Has("parameters") ? obj["parameters"] : Map()
        )

        this.LoadDefinitions(MapDefinitionLoader(newObj, "", servicesKey, parametersKey))
    }

    LoadFromJson(jsonFile, servicesKey := "", parametersKey := "") {
        if (Type(jsonFile) == "ParameterRef" || jsonFile.HasBase(ParameterRef)) {
            jsonFile := this.GetParameter(jsonFile.GetName())
        }

        this.LoadDefinitions(JsonDefinitionLoader(jsonFile, "", servicesKey, parametersKey))
    }

    Get(name) {
        return this.GetParameter(name)
    }

    resolveProperties(propertyDefinitions) {
        properties := Map()

        if (!propertyDefinitions) {
            propertyDefinitions := Map()
        }

        for propName, propDefinition in propertyDefinitions {
            properties[propName] := this.resolveDefinition(propDefinition)
        }

        return properties
    }

    resolveDefinition(definition) {
        val := definition
        isObj := IsObject(definition)

        if (isObj && (Type(definition) == "AppRef" || definition.HasBase(AppRef))) {
            val := this.GetApp(definition)
        } else if (isObj && (Type(definition) == "ContainerRef" || definition.HasBase(ContainerRef))) {
            val := this
        } else if (isObj && (Type(definition) == "ParameterRef" || definition.HasBase(ParameterRef))) {
            val := this.GetParameter(definition.GetName())
        }

        return val
    }

    GetApp(definition := "") {
        appName := definition ? definition.GetName() : ""
        
        if (!appName) {
            appName := "AppBAse"
        }

        if (this.Has(appName)) {
            return this.Get(appName)
        } else {
            return %appName%.Instance
        }
    }

    HasParameter(name) {
        exists := false
        tokens := StrSplit(name, ".")
        context := this.Parameters

        for index, token in tokens {
            if (context.Has(token)) {
                exists := false
                break
            }

            context := context[token]
        }

        return exists
    }

    GetParameter(name := "") {
        tokens := StrSplit(name, ".")
        context := this.Parameters

        for index, token in tokens {
            if (!context.Has(token)) {
                throw ParameterNotFoundException("Parameter not found: " . name)
            }

            context := context[token]
        }

        return context
    }

    SetParameter(name, value := "") {
        tokens := StrSplit(name, ".")
        context := this.Parameters

        lastToken := tokens.Pop()

        for index, token in tokens {
            if (!context.Has(token)) {
                context[token] := Map()
            }

            context := context[token]
        }

        context[lastToken] := value
    }

    MergeParameter(name, value) {
        if (Type(value) == "Map") {
            for key, mapValue in value {
                token := name . "." . key

                this.MergeParameter(token, mapValue)
            }
        } else if (Type(value) == "Array") {
            if (!this.HasParameter(name)) {
                this.SetParameter(name, value)
            } else {
                paramArray := this.GetParameter(name)

                for index, arrayValue in value {
                    paramArray.Push(arrayValue)
                }
            }
        } else {
            this.SetParameter(name, value)
        }
    }
}
