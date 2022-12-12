class AppEntityBase extends FieldableEntity {
    app := ""
    dataSourcePath := ""
    existsInDataSource := false
    mergeDataFromApi := true

    __New(app, id, entityTypeId, container, eventMgr, storageObj, idSanitizer, parentEntity := "") {
        this.app := app
    
        super.__New(id, entityTypeId, container, eventMgr, storageObj, idSanitizer, parentEntity)
    }

    static Create(container, eventMgr, id, entityTypeId, storageObj, idSanitizer, parentEntity := "") {
        className := this.Prototype.__Class

        return %className%(
            container.GetApp(),
            id,
            entityTypeId,
            container,
            eventMgr,
            storageObj,
            idSanitizer,
            parentEntity
        )
    }

    GetDefaultFieldGroups() {
        groups := super.GetDefaultFieldGroups()

        groups["advanced"] := Map(
            "name", "Advanced",
            "weight", 100
        )

        if (this.mergeDataFromApi) {
            groups["api"] := Map(
                "name", "API",
                "weight", 150
            )
        }

        return groups
    }

    BaseFieldDefinitions() {
        definitions := super.BaseFieldDefinitions()

        if (this.mergeDataFromApi) {
            definitions["DataSourceKeys"] := Map(
                "description", "The data source keys to load defaults from, in order.",
                "help", "The default data source is 'api' which connects to the default api endpoint (Which can be any HTTP location compatible with Launchpad's API format)",
                "default", [this.app.Config["data_source_key"]],
                "multiple", true,
                "group", "api",
                "processValue", false,
                "modes", Map("simple", Map("formField", false))
            )

            definitions["DataSourceItemKey"] := Map(
                "description", "The key that is used to look up the entity's data from configured external data sources.",
                "help", "It defaults to the key which is usually sufficient, but it can be overridden by setting this value.`n`nAddtionally, multiple copies of the same data source entity can exist by giving them different keys but using the same DataSourceKey",
                "group", "api",
                "processValue", false,
                "modes", Map("simple", Map("formField", false))
            )
        }

        definitions["AssetsDir"] := Map(
            "type", "directory",
            "description", "The directory where any required assets for this entity will be saved.",
            "default", this.app.Config["assets_dir"] . "\" . this.Id,
            "group", "advanced",
            "formField", false,
            "modes", Map("simple", Map("formField", false))
        )

        definitions["DependenciesDir"] := Map(
            "type", "directory",
            "description", "The directory where dependencies which have been installed for this entity can be accessed.",
            "default", this.app.appDir . "\Vendor",
            "group", "advanced",
            "required", true,
            "formField", false,
            "modes", Map("simple", Map("formField", false))
        )

        return definitions
    }

    _getLayerNames() {
        layerNames := super._getLayerNames()
        layerNames.Push("ds")

        return layerNames
    }

    _getLayerSources() {
        layerSources := super._getLayerSources()
        layerSources["ds"] := ObjBindMethod(this, "AggregateDataSourceDefaults")

        return layerSources
    }

    UpdateDataSourceDefaults(recurse := true) {
        ; @todo Move this to a module
        this.GetData().UnloadLayer("ds")

        if (recurse) {
            for key, child in this.GetReferencedEntities(true) {
                child.UpdateDataSourceDefaults(recurse)
            }
        }
    }

    AggregateDataSourceDefaults(includeParentData := true, includeChildData := true) {
        defaults := Map()

        if (this.mergeDataFromApi) {
            defaults := (this.parentEntity != "" && includeParentData) 
                ? this.parentEntity.AggregateDataSourceDefaults(includeParentData, false) 
                : defaults

            for index, dataSource in this.GetAllDataSources() {
                defaults := this.merger.Merge(this.GetDataSourceDefaults(dataSource), defaults)
            }

            if (includeChildData) {
                for key, child in this.GetReferencedEntities(true) {
                    defaults := this.merger.Merge(child.AggregateDataSourceDefaults(false, includeChildData), defaults)
                }
            }
        }

        return defaults
    }

    GetAllDataSources() {
        dataSources := Map()

        if (this.mergeDataFromApi && this.Has("DataSourceKeys", false)) {
            dataSourceKeys := this["DataSourceKeys"]

            if (!HasBase(dataSourceKeys, Array.Prototype)) {
                dataSourceKeys := [dataSourceKeys]
            }

            for index, dataSourceKey in dataSourceKeys {
                if (this.app.Service("manager.data_source").Has(dataSourceKey)) {
                    dataSource := this.app.Service("manager.data_source")[dataSourceKey]

                    if (dataSource) {
                        dataSources[dataSourceKey] := dataSource
                    }
                }
            }
        }

        return dataSources
    }

    GetDataSourceDefaults(dataSource) {
        defaults := Map()

        if (this.mergeDataFromApi) {
            itemKey := this.DiscoverDataSourceItemKey()

            if (itemKey) {
                dsData := dataSource.ReadJson(itemKey, this.GetDataSourceItemPath())

                if (dsData) {
                    this.existsInDataSource := true

                    if (dsData.Has("data")) {
                        dsData := dsData["data"]
                    }

                    if (dsData.Has("defaults")) {
                        defaults := this.merger.Merge(dsData["defaults"], defaults)
                        defaults := this.MergeAdditionalDataSourceDefaults(defaults, dsData)
                    }
                }
            }
        }

        return defaults
    }

    DiscoverDataSourceItemKey() {
        return this.Id
    }

    GetDataSourceItemPath() {
        return this.dataSourcePath
    }

    MergeAdditionalDataSourceDefaults(defaults, dataSourceData) {
        return defaults
    }

    GetAssetPath(filePath) {
        return this["AssetsDir"] . "\" . filePath
    }
}
