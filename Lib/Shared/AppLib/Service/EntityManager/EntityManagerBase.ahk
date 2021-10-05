class EntityManagerBase extends AppComponentServiceBase {
    _registerEvent := ""
    _alterEvent := ""
    configObj := ""

    Entities {
        get => this._components
        set => this._components := value
    }

    __New(app, configObj) {
        this.configObj := configObj
        super.__New(app, "", false)
    }

    LoadComponents(configFile := "") {
        this._componentsLoaded := false

        if (configFile != "") {
            this.configObj._storage.storagePath := configFile
        }

        if (this.configObj._storage.storagePath == "") {
            this.configObj._storage.storagePath := this.GetDefaultConfigPath()
        }

        operation := this.GetLoadOperation()
        success := operation.Run()
        this._components := operation.GetResults()
        super.LoadComponents() ; Allow entities to be added to or altered

        return success
    }

    GetConfig() {
        return this.configObj
    }

    CountEntities() {
        return this.Entities.Count
    }

    SaveModifiedEntities() {
        this.configObj.SaveConfig()
    }

    RemoveEntity(key) {
        if (this.Entities.Has(key)) {
            this.Entities.Delete(key)
            this.RemoveEntityFromConfig(key)
        }
    }

    AddEntity(key, entityObj) {
        this.Entities[key] := entityObj
        this.AddEntityToConfig(key, entityObj)
    }

    GetLoadOperation() {

    }

    GetDefaultConfigPath() {

    }

    RemoveEntityFromConfig(key) {

    }

    AddEntityToConfig(key, entityObj) {

    }
}
