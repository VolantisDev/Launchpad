/**
 * Base class for loading (and possibly saving) entity data
 */
class EntityStorageBase {
    entityTypeId := ""

    __New(entityTypeId) {
        this.entityTypeId := entityTypeId
    }

    static Create(entityTypeId, definition, container) {
        className := this.Prototype.__Class

        return %className%(
            entityTypeId
        )
    }

    DiscoverEntities() {
        return []
    }

    SaveData(idOrObj, data := "") {
        id := this._dereferenceId(idOrObj)
        data := this._dereferenceData(idOrObj, data)
        this._saveEntityData(id, data)
    }

    _saveEntityData(id, data) {

    }

    LoadData(idOrObj) {
        return this._loadEntityData(this._dereferenceId(idOrObj))
    }

    _loadEntityData(id) {

    }

    HasData(idOrObj) {
        return this._hasEntityData(this._dereferenceId(idOrObj))
    }

    _hasEntityData(id) {

    }

    DeleteData(idOrObj) {
        this._deleteEntityData(this._dereferenceId(idOrObj))
    }

    _dereferenceId(idOrObj) {
        if (!idOrObj) {
            throw AppException("Entity to delete was not provided")
        }
        
        if (HasBase(idOrObj, EntityBase.Prototype)) {
            idOrObj := idOrObj.GetId()
        }

        return idOrObj
    }

    _dereferenceData(idOrObj, data := "") {
        if (HasBase(idOrObj, EntityBase.Prototype) && !data) {
            data := idOrObj.UnmergedFieldData
        }

        return data
    }

    _deleteEntityData(id) {

    }
}
