class ServiceContainer extends ParameterContainer {
    serviceStore := Map()
 
    LoadDefinitions(definitionLoader, replace := true, prefix := "") {
        services := definitionLoader.LoadServiceDefinitions()

        if (services) {
            for serviceName, serviceConfig in services {
                if (prefix) {
                    serviceName := prefix . serviceName
                }

                if (!this.Has(serviceName) || replace) {
                    if (this.serviceStore.Has(serviceName)) {
                        this.serviceStore.Delete(serviceName)
                    }

                    if (Type(serviceConfig) == "String") {
                        serviceConfig := Map("class", serviceConfig)
                    }

                    this.Items[serviceName] := serviceConfig
                }
            }
        }

        super.LoadDefinitions(definitionLoader, replace, prefix)
    }

    Get(service) {
        if (!service) {
            throw ContainerException("Service name not provided")
        }

        if (!this.Has(service)) {
            throw ServiceNotFoundException("Service not found: " . service)
        }

        if (!this.serviceStore.Has(service)) {
            this.serviceStore[service] := this.createService(service)
        }

        return this.serviceStore[service]
    }

    Set(name, service) {
        if (this.serviceStore.Has(service)) {
            this.serviceStore.Delete(service)
        }

        super.Set(name, service)
    }

    Query(servicePrefix := "", resultType := "") {
        if (resultType == "") {
            resultType := ContainerQuery.RESULT_TYPE_SERVICES
        }

        return ContainerQuery(this, servicePrefix, resultType)
    }

    Delete(service, deleteDefinition := true) {
        if (this.serviceStore.Has(service)) {
            this.serviceStore.Delete(service)
        }

        if (deleteDefinition) {
            super.Delete(service)
        }
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
        factory := this.resolveDefinition(entry["factory"])

        if (Type(factory) == "String") {
            if (this.Has(factory)) {
                factory := this.Get(factory)
            } else {
                throw ContainerException("Factory service " . factory . " does not exist in the container.")
            }
        }

        arguments := entry.Has("arguments") ? this.resolveArguments(name, entry["arguments"]) : []

        if (entry.Has("method") && entry["method"]) {
            if (!HasMethod(factory, entry["method"])) {
                throw ContainerException(name " service uses factory method " . entry["method"] . " which is uncallable")
            }

            factory := ObjBindMethod(factory, entry["method"])
        }

        if (!HasMethod(factory)) {
            throw ContainerException(name . " service uses a factory which is uncallable")
        }

        return factory(arguments*)
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
            serviceName := definition.GetName()

            if (!serviceName) {
                throw ContainerException("Definition of type " . Type(definition) . " is missing a name")
            }

            val := this.Get(serviceName)

            method := definition.GetMethod()

            if (method) {
                if (!HasMethod(val, method)) {
                    throw ContainerException("Service " . definition.GetName() . " does not have method " . method)
                }

                val := ObjBindMethod(val, method)
            }
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
