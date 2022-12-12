class ManageWebServicesWindow extends ManageEntitiesWindow {
    listViewColumns := Array("SERVICE", "PROVIDER", "USER", "AUTHENTICATED", "AUTO-LOGIN")

    GetListViewData(lv) {
        data := Map()

        for key, webService in this.entityMgr {
            data[key] := [
                webService["name"],
                webService["Provider"]["name"],
                "",
                webService.Authenticated ? "Yes" : "No",
                webService["AutoLogin"] ? "Yes" : "No"
            ]
        }

        return data
    }

    GetEntityIconSrc(entityObj) {
        return entityObj["Provider"]["IconSrc"]
    }

    GetContextMenuItems(entityObj) {
        menuItems := super.GetContextMenuItems(entityObj)

        if (entityObj["Provider"]["SupportsAuthentication"]) {
            if (entityObj.Authenticated) {
                menuItems.InsertAt(1, Map("label", "&Logout", "name", "WebServiceLogout"))
            } else {
                menuItems.InsertAt(1, Map("label", "&Login", "name", "WebServiceLogin"))
            }
        }

        return menuItems
    }

    _shouldShowButton(entityObj, buttonName) {
        shouldShow := super._shouldShowButton(entityObj, buttonName)
        
        if (shouldShow && buttonName == "DeleteEntity") {
            shouldShow := entityObj.Id != "api"
        }

        return shouldShow
    }

    ProcessContextMenuResult(result, key) {
        if (result == "WebServiceLogout") {
            this.Logout(key)
        } else if (result == "WebServiceLogin") {
            this.Login(key)
        } else {
            super.ProcessContextMenuResult(result, key)
        }
    }

    Logout(key) {
        result := this.entityMgr[key].Logout()

        this.UpdateListView()

        return result
    }

    Login(key) {
        result := this.entityMgr[key].Login()
        
        this.UpdateListView()

        return result
    }

    ViewEntity(key) {
        entityObj := this.entityMgr[key]
    }

    AddEntity() {
        ; @todo open add wizard

        this.UpdateListView()
    }

    DeleteEntity(key) {
        entityObj := this.entityMgr[key]
    }
}
