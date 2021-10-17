class ComponentManagerBase {
    container := ""
    servicePrefix := ""
    eventMgr := ""
    notifierObj := ""
    definitionLoaders := ""
    componentType := "" ; Passed with events
    loaded := false

    __Item[name := ""] {
        get => this.GetComponent(name)
        set => this.SetComponent(name, value)
    }

    __Enum(numberOfVars) {
        return this.All().__Enum(numberOfVars)
    }

    __New(container, servicePrefix, eventMgr, notifierObj, componentType, definitionLoaders := "", autoLoad := true) {
        this.container := container
        this.servicePrefix := servicePrefix
        this.eventMgr := eventMgr
        this.notifierObj := notifierObj

        if (Type(componentType) == "String" && IsSet(%componentType%) && HasMethod(%componentType%)) {
            componentType := %componentType%
        }

        this.componentType := componentType

        if (definitionLoaders && Type(definitionLoaders) != "Array") {
            definitionLoaders := [definitionLoaders]
        }

        this.definitionLoaders := definitionLoaders

        if (autoLoad) {
            this.LoadComponents()
        }

        event := ComponentManagerEvent(ComponentEvents.COMPONENT_MANAGER_STARTED, this)
        this.eventMgr.DispatchEvent(ComponentEvents.COMPONENT_MANAGER_STARTED, event)
    }

    GetComponentType() {
        return this.componentType
    }

    LoadComponents(reloadComponents := false) {
        if (this.loaded && !reloadComponents) {
            return
        }

        services := Map()
        parameters := Map()

        if (this.definitionLoaders) {
            for index, loader in this.definitionLoaders {
                for key, def in loader.LoadServiceDefinitions() {
                    services[key] := def
                }

                for key, def in loader.LoadParameterDefinitions() {
                    parameters[key] := def
                }
            }
        }

        event := ComponentDefinitionsEvent(ComponentEvents.COMPONENT_DEFINITIONS, this, services, parameters)
        this.eventMgr.DispatchEvent(ComponentEvents.COMPONENT_DEFINITIONS, event)

        event := ComponentDefinitionsEvent(ComponentEvents.COMPONENT_DEFINITIONS_ALTER, this, event.GetDefinitions(), event.GetParameters())
        this.eventMgr.DispatchEvent(ComponentEvents.COMPONENT_DEFINITIONS_ALTER, event)

        services := event.GetDefinitions()
        parameters := event.GetParameters()

        this.ValidateComponentDependencies(services, parameters, "before")
        this._loadDefinitions(SimpleDefinitionLoader(services, parameters))

        this.loaded := true

        this.ValidateComponentDependencies(services, parameters, "after")

        event := ComponentManagerEvent(ComponentEvents.COMPONENTS_LOADED, this)
        this.eventMgr.DispatchEvent(ComponentEvents.COMPONENTS_LOADED, event)
    }

    _loadDefinitions(loader) {
        return this.container.LoadDefinitions(loader, true, this.servicePrefix)
    }

    ValidateComponentDependencies(services, parameters, stage) {
        ; Optional method to throw exceptions in if the loaded definitions do not validate
    }

    UnloadComponents(deleteDefinitions := false) {
        if (!this.loaded) {
            return
        }

        for componentId, component in this.All() {
            this.UnloadComponent(componentId, deleteDefinitions)
        }

        this.loaded := false
    }

    UnloadComponent(componentId, deleteDefinition := false) {
        if (this.Has(componentId)) {
            this.container.Delete(this.servicePrefix . componentId, deleteDefinition)
        }
    }

    SetComponents(components) {
        for componentId, serviceDefinition in components {
            this.SetComponent(componentId, serviceDefinition)
        }
    }

    SetComponent(componentId, serviceDefinition) {
        this.container.Set(this.servicePrefix . componentId, serviceDefinition)
    }

    GetComponent(componentId := "") {
        if (!this.loaded) {
            this.LoadComponents()
        }

        if (!componentId) {
            componentId := this.GetDefaultComponentId()
        }

        return this.container.Get(this.servicePrefix . componentId)
    }

    GetDefaultComponentId() {
        return ""
    }

    All(resultType := "", returnQuery := false, includeDisabled := false) {
        if (!this.loaded) {
            this.LoadComponents()
        }

        if (!resultType) {
            resultType := ContainerQuery.RESULT_TYPE_SERVICES
        }

        query := this.Query(resultType, includeDisabled)
        return returnQuery ? query : query.Execute()
    }

    Names(includeDisabled := false) {
        names := []

        for index, name in this.getAllNames(includeDisabled) {
            start := 0

            if (this.servicePrefix) {
                start := StrLen(this.servicePrefix)+1
            }

            names.Push(SubStr(name, start))
        }

        return names
    }

    getAllNames(includeDisabled := false) {
        return this.All(ContainerQuery.RESULT_TYPE_NAMES, false, includeDisabled)
    }

    Count(includeDisabled := false) {
        return this.Names(includeDisabled).Length
    }

    Query(resultType := "", includeDisabled := false) {
        if (!this.loaded) {
            this.LoadComponents()
        }

        return this.container.Query(this.servicePrefix, resultType, includeDisabled)
    }

    Has(componentId, checkLoaded := false) {
        if (!this.loaded) {
            this.LoadComponents()
        }

        exists := this.container.Has(this.servicePrefix . componentId)

        if (exists && checkLoaded) {
            exists := this.container.serviceStore.Has(this.servicePrefix . componentId)
        }

        return exists
    }
}
