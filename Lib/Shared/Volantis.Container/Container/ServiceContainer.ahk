class ServiceContainer extends ParameterContainer {
    serviceStore := Map()
 
    LoadDefinitions(definitionLoader, replace := true) {
        services := definitionLoader.LoadServiceDefinitions()

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

        super.LoadDefinitions(definitionLoader, replace)
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
        
        this.validateServiceDefinition(name, entry)

        service := entry.Has("service") ? entry["service"] : ""
        entry["lock"] := true

        if (entry.Has("service") && entry["service"]) {
            service := entry["service"]
        } else if (entry.Has("factory") && entry["factory"]) {
            service := this.createServiceFromFactory(name, entry)
        } else if (entry.Has("class") && entry["class"]) {
            service := this.createServiceFromClass(name, entry)
        } else if (entry.Has("com") && entry["com"]) {
            service := this.createServiceFromComObject(name, entry)
        } else {
            throw ContainerException(name . " service is of unknown type")
        }
        
        if (!service) {
            throw ContainerException(name . " service failed to load for an unknown reason")
        }

        this.initializeService(service, name, entry)

        return service
    }

    validateServiceDefinition(name, entry) {
        if (Type(entry) != "Map") {
            throw ContainerException(name . " service entry must be a map but it is a " . Type(entry))
        }

        requiresOneOf := ["class", "service", "factory", "com"]
        hasRequiredKey := false

        for index, serviceKey in requiresOneOf {
            if (entry.Has(serviceKey) && entry[serviceKey]) {
                hasRequiredKey := true
                break
            }
        }

        if (!hasRequiredKey) {
            throw ContainerException(name . " service entry must contain one of the following keys: class, service, factory, or com")
        }

        if (entry.Has("lock")) {
            throw ContainerException(name . " service contains a circular reference")
        }
    }

    createServiceFromClass(name, entry) {
        className := entry["class"]
        arguments := entry.Has("arguments") ? this.resolveArguments(name, entry["arguments"]) : []

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

        return service
    }

    createServiceFromComObject(name, entry) {
        return ComObject(entry["com"])
    }

    createServiceFromFactory(name, entry) {
        factory := entry["factory"]

        if (!HasMethod(factory)) {
            throw ContainerException(name . " service uses a factory which is uncallable")
        }

        if (HasMethod(factory)) {
            return %factory%(this)
        }
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

    resolveDefinition(definition) {
        val := definition
        isObj := IsObject(definition)

        if (isObj && definition.HasBase(ServiceRef.Prototype)) {
            val := this.Get(definition.GetName())
        }

        return super.resolveDefinition(val)
    }

    initializeService(service, name, entry) {
        callDefinitions := entry.Has("calls") ? entry["calls"] : []

        if (Type(callDefinitions) == "Map") {
            callDefinitions := [callDefinitions]
        }

        propDefinitions := entry.Has("props") ? entry["props"] : Map()

        if (callDefinitions && callDefinitions.Length) {
            for index, callDefinition in callDefinitions {
                if (Type(callDefinition) != "Map" || !callDefinition.Has("method")) {
                    throw ContainerException(name . " service calls must be arrays containing a 'method' key")
                } else if (!service.HasMethod(callDefinition["method"])) {
                    throw ContainerException(name " service asks for call to uncallable method: " . callDefinition["method"])
                }

                arguments := callDefinition.Has("arguments") ? this.resolveArguments(name, callDefinition["arguments"]) : []

                if (!service.HasMethod(callDefinition["method"], arguments.Length)) {
                    throw ContainerException(name . " has invalid callback method defined: " . callDefinition["method"])
                }

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
}
