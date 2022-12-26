class ServiceContainer extends ParameterContainer {
    serviceStore := Map()
    parametersObj := ""

    /**
     * Extend Has method to support service namespaces
     */
    Has(key) {
        return super.Has(key) || !!this.GetNamespace(key)
    }

    /**
     * Check if a namespace service is defined and return the name of the most specific one
     */
    GetNamespace(key) {
        services := this.Query("", ContainerQuery.RESULT_TYPE_DEFINITIONS)
            .Condition(NamespaceMatchesCondition(key))
            .Execute()
        
        namespaceService := ""
        matchingNamespace := ""

        for serviceName, serviceDefinition in services {
            serviceNs := serviceDefinition["namespace"] 

            if (!matchingNamespace || StrLen(matchingNamespace) <= StrLen(serviceNs)) {
                namespaceService := serviceName
                matchingNamespace := serviceNs
            }
        }

        return namespaceService
    }
 
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

                    if (!serviceConfig.Has("enabled")) {
                        serviceConfig["enabled"] := true
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

    Query(servicePrefix := "", resultType := "", includeDisabled := false, removePrefix := false) {
        if (resultType == "") {
            resultType := ContainerQuery.RESULT_TYPE_SERVICES
        }

        query := ContainerQuery(this, servicePrefix, resultType, removePrefix)

        if (!includeDisabled) {
            query.Condition(FieldCondition(IsTrueCondition(), "enabled", false, true, true))
        }

        return query
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
        entry := this.Items.Has(name) ? this.Items[name] : this.GetNamespace(name)

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
        if (!HasBase(entry, Map.Prototype)) {
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

        if (argumentDefinitions && !HasBase(argumentDefinitions, Array.Prototype)) {
            argumentDefinitions := [argumentDefinitions]
        }

        if (argumentDefinitions != "") {
            for index, argumentDefinition in argumentDefinitions {
                arguments.Push(this.resolveDefinition(argumentDefinition))
            }
        }
        

        return arguments
    }

    initializeService(service, name, entry) {
        callDefinitions := entry.Has("calls") ? entry["calls"] : []

        if (HasBase(callDefinitions, Map.Prototype)) {
            callDefinitions := [callDefinitions]
        }

        propDefinitions := entry.Has("props") ? entry["props"] : Map()

        if (callDefinitions && callDefinitions.Length) {
            for index, callDefinition in callDefinitions {
                if (!HasBase(callDefinition, Map.Prototype) || !callDefinition.Has("method")) {
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

            for propName, propValue in props {
                service.%propName% := propValue
            }
        }
    }
}
