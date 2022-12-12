class ManageWebServicesWindow extends ManageEntitiesWindow {
    listViewColumns := Array("SERVICE", "PROVIDER", "AUTHENTICATED")

    GetListViewData(lv) {
        data := Map()

        for key, webService in this.entityMgr {
            data[key] := [
                webService["name"],
                webService["Provider"]["name"],
                webService.AuthData["authenticated"] ? "Yes" : "No"
            ]
        }

        return data
    }

    GetEntityIconSrc(entityObj) {
        return entityObj["Provider"]["IconSrc"]
    }

    ViewEntity(key) {
        ; @todo generic view operation for double-clicking non-editable entities
    }

    AddEntity() {
        ; @todo Implement generic add dialog and operation
    }

    DeleteEntity(key) {
        ; @todo Implement generic delete dialog and operation
    }
}
