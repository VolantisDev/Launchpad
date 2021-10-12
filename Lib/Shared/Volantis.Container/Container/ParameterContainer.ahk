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

    LoadDefinitions(definitionLoader, replace := true, prefix := "") {
        parameters := definitionLoader.LoadParameterDefinitions()

        if (parameters) {
            for paramName, paramConfig in parameters {
                if (prefix) {
                    paramName := prefix . paramName
                }

                if (!this.Parameters.Has(paramName) || replace) {
                    this.SetParameter(paramName, paramConfig)
                }
            }
        }
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
        if (Type(definition) == "String" || Type(definition) == "Map" || Type(definition) == "Array") {
            definition := this.ExpandTextReferences(definition)
        }

        val := definition
        isObj := IsObject(definition)

        if (Type(val) == "String" || Type(val) == "Map" || Type(val) == "Array") {
            val := this.ExpandTextReferences(definition)
        }

        if (isObj && (definition.HasBase(AppRef.Prototype))) {
            val := this.GetApp(definition)
        } else if (isObj && definition.HasBase(ContainerRef.Prototype)) {
            val := this
        } else if (isObj && definition.HasBase(ParameterRef.Prototype)) {
            val := this.GetParameter(definition.GetName())
        }

        return val
    }

    /*
        Example tokens:
          - {@App} -> AppRef()
          - {@Container} -> ContainerRef()
          - {@Service:EventManager} -> ServiceRef("EventManager")
          - {@Service:EventManager:methodName} -> ServiceRef("EventManager", "methodName")
    */
    ExpandTextReferences(data) {
        if (Type(data) == "Array" || Type(data) == "Map") {
            for index, value in data {
                data[index] := this.ExpandTextReferences(value)
            }
        } else if (Type(data) == "String") {
            tokenPattern := "^{@([^:}]+)(:([^:}]+))?(:([^:}]+))?}$"
            pos := RegExMatch(data, tokenPattern, &matches)

            if (pos) {
                className := matches[1] . "Ref"
                args := []

                if (matches.Count >= 3 && matches[3]) {
                    args.Push(matches[3])
                }

                if (matches.Count >= 5 && matches[5]) {
                    args.Push(matches[5])
                }

                if (!HasMethod(%className%)) {
                    throw ContainerException("Reference type " . className . " does not exist")
                }

                data := %className%(args*)
            }
        }

        return data
    }

    GetApp(definition := "") {
        appName := definition ? definition.GetName() : ""
        
        if (!appName) {
            appName := "AppBase"
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
                context := context[token]
                exists := true
            } else {
                exists := false
                break
            }
        }

        return exists
    }

    GetParameter(name := "") {
        tokens := StrSplit(name, ".")
        context := this.Parameters

        for index, token in tokens {
            if (!context.Has(token)) {
                throw ContainerException("Parameter not found: " . name)
            }

            context := context[token]
        }

        return context
    }

    DeleteParameter(name) {
        if (!name) {
            throw ContainerException("You must specify a parameter to delete")
        }

        tokens := StrSplit(name, ".")
        context := this.Parameters
        lastToken := tokens.Pop()

        for index, token in tokens {
            if (!context.Has(token)) {
                throw ContainerException("Parameter not found: " . name)
            }

            context := context[token]
        }

        if (!context || !context.Has(lastToken)) {
            throw ContainerException("Parameter not found: " . name)
        }

        context.Delete(lastToken)
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
