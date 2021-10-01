class ServiceContainer extends ContainerBase {
    parametersObj := Map()
    serviceStore := Map()

    Parameters {
        get => this.parametersObj
    }
    
    __New(services := "", parameters := "") {
        if (parameters) {
            this.parametersObj := parameters
        }

        super.__New(services)
    }

    AddDefinitions(services := "", parameters := "", replace := false) {
        if (services) {
            for serviceName, serviceConfig in services {
                if (!this.Has(serviceName) || replace) {
                    if (this.serviceStore.Has(serviceName)) {
                        this.serviceStore.Delete(serviceName)
                    }

                    this.Items[serviceName] := serviceConfig
                }
            }
        }

        if (parameters) {
            for paramName, paramConfig in parameters {
                if (!this.Parameters.Has(paramName) || replace) {
                    this.Parameters[paramName] := paramConfig
                }
            }
        }
    }

    Get(service) {
        if (!this.Has(service)) {
            throw ServiceNotFoundException("Service not found: " . service)
        }

        if (!this.serviceStore.Has(service)) {
            this.serviceStore[service] := this.createService(service)
        }

        return this.serviceStore[service]
    }

    createService(name) {
        entry := this.Items[name]

        if (Type(entry) == "String" && entry) {
            entry := Map("class", entry)
        }
        
        if (Type(entry) != "Map") {
            throw ContainerException(name . " service entry must be a map but it is a " . Type(entry))
        } else if ((!entry.Has("class") || !entry["class"]) && (!entry.Has("service") || !entry["service"]) && (!entry.Has("com") || !entry["com"])) {
            throw ContainerException(name . " service entry must contain a 'class', 'service', or 'com' key")
        } else if (entry.Has("lock")) {
            throw ContainerException(name . " service contains a circular reference")
        }

        service := entry.Has("service") ? entry["service"] : ""
        entry["lock"] := true

        if (!service) {
            arguments := entry.Has("arguments") ? this.resolveArguments(name, entry["arguments"]) : []

            if (entry.Has("class")) {
                className := entry["class"]

                if (!IsSet(%className%)) {
                    throw ContainerException(name . " service class does not exist: " . className)
                }

                if (!%className%.HasMethod("Call", arguments.Length)) {
                    throw ContainerException(name . " service is not callable with the supplied arguments")
                }

                try {
                    service := %className%(arguments*)
                } catch as er {
                    er.Message := name . " service could not be created: " . er.Message
                    throw er
                }
                
            } else if (entry.Has("com")) {
                service := ComObject(entry["com"])
            } else {
                throw ContainerException(name . " service is of unknown type")
            }
        }
        
        if (!service) {
            throw ContainerException(name . " service failed to load")
        }

        calls := entry.Has("calls") ? entry["calls"] : []
        props := entry.Has("props") ? entry["props"] : Map()

        if (calls.Length || props.Count) {
            this.initializeService(service, name, calls, props)
        }

        return service
    }

    resolveArguments(name, argumentDefinitions) {
        arguments := []

        if (argumentDefinitions && Type(argumentDefinitions) != "Array") {
            argumentDefinitions := [argumentDefinitions]
        }

        if (argumentDefinitions != "") {
            for index, argumentDefinition in argumentDefinitions {
                arguments.Push(this.resolveDefinition(argumentDefinition))
            }
        }
        

        return arguments
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
            appClass := definition.GetName()
            val := appClass ? %appClass%.Instance : AppBase.Instance
        } else if (isObj && (Type(definition) == "ServiceRef" || definition.HasBase(ServiceRef))) {
            val := this.Get(definition.GetName())
        } else if (isObj && (Type(definition) == "ParameterRef" || definition.HasBase(ParameterRef))) {
            val := this.GetParameter(definition.GetName())
        }

        return val
    }

    initializeService(service, name, callDefinitions, propDefinitions) {
        if (callDefinitions && callDefinitions.Length) {
            for index, callDefinition in callDefinitions {
                if (Type(callDefinition) != "Map" || !callDefinition.Has("method")) {
                    throw ContainerException(name . " service calls must be arrays containing a 'method' key")
                } else if (!service.HasMethod(callDefinition["method"])) {
                    throw ContainerException(name " service asks for call to uncallable method: " . callDefinition["method"])
                }

                arguments := callDefinition.Has("arguments") ? this.resolveArguments(name, callDefinition["arguments"]) : []
                method := service.GetMethod(callDefinition["method"], arguments.Length)

                method(service, arguments*)
            }
        }
        
        if (propDefinitions && propDefinitions.Count) {
            props := this.resolveProperties(propDefinitions)
            entry := this.Items[name]

            for propName, propValue in props {
                service.%propName% := propValue
            }
        }
    }

    GetParameter(name) {
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
}
