class ManageWebServicesWindow extends ManageEntitiesWindow {
    listViewColumns := Array("ID", "PROVIDER", "NAME", "AUTHENTICATED")

    GetListViewData(lv) {
        data := Map()

        for key, webService in this.entityMgr {
            data[key] := [
                webService["id"],
                webService["Provider"]["name"],
                webService["name"],
                webService.AuthData["authenticated"] ? "Yes" : "No"
            ]
        }

        return data
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
