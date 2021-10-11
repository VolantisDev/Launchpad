class ComponentManagerBase {
    container := ""
    servicePrefix := ""
    eventMgr := ""
    notifierObj := ""
    definitionLoader := ""
    componentType := "" ; Passed with events
    loaded := false

    __Item[name := ""] {
        get => this.GetComponent(name)
        set => this.SetComponent(name, value)
    }

    __Enum(numberOfVars) {
        return this.All().__Enum(numberOfVars)
    }

    __New(container, servicePrefix, eventMgr, notifierObj, componentType, definitionLoader := "", autoLoad := true) {
        this.container := container
        this.servicePrefix := servicePrefix
        this.eventMgr := eventMgr
        this.notifierObj := notifierObj

        if (Type(componentType) == "String" && IsSet(%componentType%) && HasMethod(%componentType%)) {
            componentType := %componentType%
        }

        this.componentType := componentType
        this.definitionLoader := definitionLoader

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

        if (this.definitionLoader) {
            services := this.definitionLoader.LoadServiceDefinitions()
            parameters := this.definitionLoader.LoadParameterDefinitions()
        }

        event := ComponentDefinitionsEvent(ComponentEvents.COMPONENT_DEFINITIONS, this, services, parameters)
        this.eventMgr.DispatchEvent(ComponentEvents.COMPONENT_DEFINITIONS, event)

        event := ComponentDefinitionsEvent(ComponentEvents.COMPONENT_DEFINITIONS_ALTER, this, event.GetDefinitions(), event.GetParameters())
        this.eventMgr.DispatchEvent(ComponentEvents.COMPONENT_DEFINITIONS_ALTER, event)

        loader := SimpleDefinitionLoader(event.GetDefinitions(), event.GetParameters())
        this.container.LoadDefinitions(loader, true, this.servicePrefix)

        this.loaded := true

        event := ComponentManagerEvent(ComponentEvents.COMPONENTS_LOADED, this)
        this.eventMgr.DispatchEvent(ComponentEvents.COMPONENTS_LOADED, event)
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

    All(resultType := "") {
        if (!this.loaded) {
            this.LoadComponents()
        }

        if (!resultType) {
            resultType := ContainerQuery.RESULT_TYPE_SERVICES
        }

        query := this.Query(resultType)
        results := query.Execute()

        return results
    }

    Names() {
        return this.All(ContainerQuery.RESULT_TYPE_NAMES)
    }

    Query(resultType := "") {
        if (!this.loaded) {
            this.LoadComponents()
        }

        return this.container.Query(this.servicePrefix, resultType)
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
