class PlatformManager extends EntityManagerBase {
    guiManagerObj := ""

    __New(container, entityTypeId, guiManagerObj, eventMgr, notifierObj, storageObj, factoryObj, componentType, definitionLoaders := "", autoLoad := false) {
        this.guiManagerObj := guiManagerObj
        super.__New(container, entityTypeId, eventMgr, notifierObj, storageObj, factoryObj, componentType, definitionLoaders, autoLoad)
    }

    static Create(entityTypeId, definition, container) {
        className := this.Prototype.__Class
        manager := container.Get("manager.entity_type")

        return %className%(
            container,
            entityTypeId,
            container.Get("manager.gui"),
            container.Get(definition["event_manager"]),
            container.Get(definition["notifier"]),
            manager.GetStorage(entityTypeId),
            manager.GetFactory(entityTypeId),
            definition["entity_class"],
            manager.GetDefinitionLoader(entityTypeId)
        )
    }

    GetActivePlatforms(resultType := "ids") {
        return this._getActiveQuery(resultType).Execute()
    }

    GetGameDetectionPlatforms() {
        return this._getActiveQuery(EntityQuery.RESULT_TYPE_ENTITIES)
            .Condition(IsTrueCondition(), "DetectGames")
            .Execute()
    }

    _getActiveQuery(resultType := "ids") {
        return this.EntityQuery(resultType)
            .Condition(IsTrueCondition(), "IsEnabled")
            .Condition(IsTrueCondition(), "IsInstalled")
    }
    
    DetectGames() {
        platforms := this.GetGameDetectionPlatforms()
        op := DetectGamesOp(this.container.GetApp(), platforms)
        op.Run()

        allDetectedGames := Map()

        for key, detectedGames in op.GetResults() {
            for index, detectedGameObj in detectedGames {
                allDetectedGames[detectedGameObj.key] := detectedGameObj
            }
        }

        this.guiManagerObj.OpenWindow("DetectedGamesWindow", allDetectedGames)
    }
}
