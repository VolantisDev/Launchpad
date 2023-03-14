class ParentEntityLayerSource extends LayerSourceBase {
    entityObj := ""

    __New(entityObj) {
        this.entityObj := entityObj
    }
    
    SaveData(data := "") {
        this._validateParentEntity()

        this.entityObj.ParentEntity
            .SetChildEntityData(this.entityObj.EntityTypeId, this.entityObj.Id, data)

        return this
    }

    LoadData() {
        this._validateParentEntity()

        return this.entityObj.ParentEntity
            .GetChildEntityData(this.entityObj.EntityTypeId, this.entityObj.Id)
    }

    HasData() {
        this._validateParentEntity()

        return this.entityObj.ParentEntity
            .HasChildEntityData(this.entityObj.EntityTypeId, this.entityObj.Id)
    }

    DeleteData() {
        this._validateParentEntity()

        this.entityObj.ParentEntity
            .DeleteChildEntityData(this.entityObj.EntityTypeId, this.entityObj.Id)

        return this
    }

    _validateParentEntity() {
        if (!this.entityObj.ParentEntity) {
            throw AppException("Parent entity not set.")
        }

        if (!HasBase(this.entityObj.ParentEntity, EntityBase.Prototype)) {
            throw AppException("Parent entity is not an entity.")
        }

        parentData := this.entityObj.ParentEntity.GetData()

        if (!parentData) {
            throw AppException("Parent entity data is not set.")
        }
    }
}
