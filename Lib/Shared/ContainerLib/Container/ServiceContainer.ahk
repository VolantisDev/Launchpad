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
            val := this.GetApp(definition)
        } else if (isObj && (Type(definition) == "ContainerRef" || definition.HasBase(ContainerRef))) {
            val := this
        } else if (isObj && (Type(definition) == "ServiceRef" || definition.HasBase(ServiceRef))) {
            val := this.Get(definition.GetName())
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

    initializeService(service, name, entry) {
        callDefinitions := entry.Has("calls") ? entry["calls"] : []
        propDefinitions := entry.Has("props") ? entry["props"] : Map()

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
