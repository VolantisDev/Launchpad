class ManageWebServicesWindow extends ManageEntitiesWindow {
    listViewColumns := Array("SERVICE", "PROVIDER", "USER", "AUTHENTICATED")

    GetListViewData(lv) {
        data := Map()

        for key, webService in this.entityMgr {
            data[key] := [
                webService["name"],
                webService["Provider"]["name"],
                webService.UserId ? webService.UserId : "None",
                webService.Authenticated ? "Yes" : "No"
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
        return this.entityMgr[key].Logout()
    }

    Login(key) {
        return this.entityMgr[key].Login()
    }

    ViewEntity(key) {
        entityObj := this.entityMgr[key]
    }

    AddEntity() {
        
    }

    DeleteEntity(key) {
        entityObj := this.entityMgr[key]
    }
}
