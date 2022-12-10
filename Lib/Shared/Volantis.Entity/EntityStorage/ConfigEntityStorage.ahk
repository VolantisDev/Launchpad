/**
 * Base class for loading (and possibly saving) entity data in a config object
 */
class ConfigEntityStorage extends EntityStorageBase {
    configObj := ""

    __New(entityTypeId, configObj) {
        this.configObj := configObj
        super.__New(entityTypeId)
    }

    static Create(entityTypeId, definition, container) {
        className := this.Prototype.__Class

        return %className%(
            entityTypeId,
            container.Get(definition["storage_config_service"])
        )
    }

    DiscoverEntities() {
        this.configObj.LoadConfig(true)
        return this.configObj.Keys()
    }

    _saveEntityData(id, data) {
        this.configObj.LoadConfig()
        this.configObj.Set(id, data)
        this.configObj.SaveConfig()
    }

    _loadEntityData(id) {
        this.configObj.LoadConfig()
        return this.configObj.Has(id) ? this.configObj.Get(id) : Map()
    }

    _hasEntityData(id) {
        this.configObj.LoadConfig()
        return this.configObj.Has(id)
    }

    _deleteEntityData(id) {
        this.configObj.LoadConfig()
        this.configObj.Delete(id)
        this.configObj.SaveConfig()
    }
}
