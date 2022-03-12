class AppEntityBase extends EntityBase {
    app := ""
    dataSourcePath := ""
    existsInDataSource := false

    /**
    * BASE SETTINGS
    * 
    * These are the main pieces of data that is interacted with and that all of the other settings are pulled from.
    */

    ; The data source keys to load defaults from, in order.
    ; The default datasource is "api" which connects to the default api endpoint (Which can be any HTTP location compatible with Launchpad's API format)
    DataSourceKeys {
        get => this.GetConfigValue("DataSourceKeys", false)
        set => this.SetConfigValue("DataSourceKeys", value, false)
    }

    ; The key that is used to look up the entity's data from configured external datasources.
    ; It defaults to the key which is usually sufficient, but it can be overridden by setting this value.
    ; Addtionally, multiple copies of the same datasource entity can exist by giving them different keys but using the same DataSourceKey
    DataSourceItemKey {
        get => this.GetConfigValue("DataSourceItemKey", false)
        set => this.SetConfigValue("DataSourceItemKey", value, false)
    }

    ; The directory where any required assets for this entity will be saved.
    AssetsDir {
        get => this.GetConfigValue("AssetsDir", false)
        set => this.SetConfigValue("AssetsDir", value, false)
    }

    ; The directory where dependencies which have been installed for this entity can be accessed
    DependenciesDir {
        get => this.GetConfigValue("DependenciesDir", false)
        set => this.SetConfigValue("DependenciesDir", value, false)
    }

    __New(app, key, configObj, parentEntity := "", requiredConfigKeys := "") {
        InvalidParameterException.CheckTypes("EntityBase", "app", app, "AppBase")

        this.app := app
    
        super.__New(key, configObj, parentEntity, requiredConfigKeys)
    }

    static createEntity(container, key, configObj, parentEntity := "", requiredConfigKeys := "") {
        className := this.Prototype.__Class

        return %className%(
            container.GetApp(), 
            key, 
            configObj, 
            parentEntity, 
            requiredConfigKeys
        )
    }

    getEntityLayers() {
        return ["ds"]
    }

    populateEntityLayers(layeredData) {
        this.entityData.SetLayer("ds", this.AggregateDataSourceDefaults())
    }

    UpdateDataSourceDefaults() {
        this.entityData.SetLayer("ds", this.AggregateDataSourceDefaults())
        this.entityData.SetLayer("auto", this.AutoDetectValues())

        for key, child in this.children {
            child.UpdateDataSourceDefaults()
        }
    }

    ; NOTICE: Object not yet fully loaded. Might not be safe to call this.entityData
    InitializeDefaults() {
        defaults := super.InitializeDefaults()
        defaults["DataSourceKeys"] := [this.app.Config["data_source_key"]]
        defaults["DataSourceItemKey"] := ""
        defaults["AssetsDir"] := this.app.Config["assets_dir"] . "\" . this.keyVal
        defaults["DependenciesDir"] := this.app.appDir . "\Vendor"
        return defaults
    }

    AggregateDataSourceDefaults(includeParentData := true, includeChildData := true) {
        dataSources := this.GetAllDataSources()
        defaults := (this.parentEntity != "" && includeParentData) ? this.parentEntity.AggregateDataSourceDefaults(includeParentData, false) : Map()

        this.entityData.SetLayer("ds", defaults)

        for index, dataSource in dataSources {
            defaults := this.MergeFromObject(defaults, this.GetDataSourceDefaults(dataSource), false)
        }

        if (includeChildData) {
            for key, child in this.children {
                defaults := this.MergeFromObject(defaults, child.AggregateDataSourceDefaults(false, includeChildData), false)
            }
        }

        return defaults
    }

    GetAllDataSources() {
        dataSources := Map()

        if (this.DataSourceKeys != "") {
            dataSourceKeys := (Type(this.DataSourceKeys) == "Array") ? this.DataSourceKeys : [this.DataSourceKeys]

            for index, dataSourceKey in dataSourceKeys {
                if (this.app.Service("manager.datasource").Has(dataSourceKey)) {
                    dataSource := this.app.Service("manager.datasource")[dataSourceKey]

                    if (dataSource != "") {
                        dataSources[dataSourceKey] := dataSource
                    }
                }
            }
        }

        return dataSources
    }

    GetDataSourceDefaults(dataSource) {
        defaults := Map()
        itemKey := this.GetDataSourceItemKey()

        if (itemKey) {
            dsData := dataSource.ReadJson(itemKey, this.GetDataSourceItemPath())

            if (dsData) {
                this.existsInDataSource := true

                if (dsData.Has("data")) {
                    dsData := dsData["data"]
                }

                if (dsData.Has("defaults")) {
                    defaults := this.MergeFromObject(defaults, dsData["defaults"], false)
                    defaults := this.MergeAdditionalDataSourceDefaults(defaults, dsData)
                }
            }
        }

        return defaults
    }

    GetDataSourceItemKey() {
        return this.Key
    }

    GetDataSourceItemPath() {
        return this.dataSourcePath
    }

    MergeAdditionalDataSourceDefaults(defaults, dataSourceData) {
        return defaults
    }

    GetAssetPath(filePath) {
        return this.AssetsDir . "\" . filePath
    }
}
