class EntityManagerBase extends AppComponentServiceBase {
    _registerEvent := ""
    _alterEvent := ""
    configObj := ""

    Entities {
        get => this._components
        set => this._components := value
    }

    __New(app, configFile := "") {
        this.configObj := this.CreateConfigObj(app, configFile)
        super.__New(app, "", false)
    }

    LoadComponents(configFile := "") {
        this._componentsLoaded := false

        if (configFile != "") {
            this.configObj.ConfigPath := configFile
        }

        if (this.configObj.ConfigPath == "") {
            this.configObj.ConfigPath := this.GetDefaultConfigPath()
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

    CreateConfigObj(configFile) {

    }

    GetDefaultConfigPath() {

    }

    RemoveEntityFromConfig(key) {

    }

    AddEntityToConfig(key, entityObj) {

    }
}
