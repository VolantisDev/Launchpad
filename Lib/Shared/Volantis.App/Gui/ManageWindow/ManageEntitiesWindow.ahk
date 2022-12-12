class ManageEntitiesWindow extends ManageWindowBase {
    listViewColumns := Array("ID", "NAME")
    entityMgr := ""
    entityTypeId := ""
    entityType := ""
    viewMode := ""

    __New(container, themeObj, config) {
        if (!this.entityTypeId && (!config.Has("entity_type") || !config["entity_type"])) {
            throw AppException("entity_type missing from window config.")
        }

        if (config.Has("entity_type") && config["entity_type"]) {
            this.entityTypeId := config["entity_type"]
        }

        this.entityType := container.Get("entity_type." . this.entityTypeId)
        this.entityMgr := container.Get("entity_manager." . this.entityTypeId)
        this.lvCount := this.entityMgr.Count(true)
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["entity_type"] := this.entityTypeId
        defaults["title"] := this.entityType.namePlural
        return defaults
    }

    AddBottomControls(y) {
        if (this.entityType.definition["allow_add"]) {
            position := "x" . this.margin . " y" . y
            this.AddManageButton("AddButton", position, "add", true)
        }
    }

    GetListViewData(lv) {
        data := Map()

        for key, entityObj in this.entityMgr {
            data[key] := [entityObj.Id, entityObj.Name]
        }

        return data
    }

    ShouldHighlightRow(key, data) {
        return false
    }

    GetViewMode() {
        typeViewMode := this.entityType.definition["manager_view_mode"]
        viewMode := typeViewMode ? typeViewMode : "List"
        viewModeParam := this.entityType.definition["manager_view_mode"]

        if (viewModeParam) {
            paramMode := this.container.GetParameter(viewModeParam)

            if (paramMode) {
                viewMode := paramMode
            }
        }

        return viewMode
    }

    GetListViewImgList(lv, large := false) {
        IL := IL_Create(this.entityMgr.Count(true), 1, large)
        defaultIconName := this.entityType.definition["default_icon"]

        if (!defaultIconName) {
            defaultIconName := "cube-outline"
        }

        defaultIcon := this.themeObj.GetIconPath(defaultIconName)
        iconNum := 1
        iconField := this.entityType.definition["icon_field"]

        for key, entityObj in this.entityMgr {
            iconSrc := entityObj[iconField]

            if (!InStr(iconSrc, ":\")) {
                iconSrc := this.themeObj.GetIconPath(iconSrc)
            }

            if (!iconSrc or !FileExist(iconSrc)) {
                iconSrc := defaultIcon
            }

            IL_Add(IL, iconSrc)
            iconNum++
        }

        return IL
    }

    OnDoubleClick(LV, rowNum) {
        key := this.listView.GetRowKey(rowNum)

        if (this.entityType.definition["allow_edit"]) {
            this.EditEntity(key)
        } else if (this.entityType.definition["allow_view"]) {
            this.ViewEntity(key)
        }
    }

    EditEntity(key) {
        entityObj := this.entityMgr[key]
        diff := entityObj.Edit("config", this.guiId)

        if (diff != "" && diff.HasChanges()) {
            entityObj.SaveEntity()
            this.UpdateListView()
        }
    }

    OnAddButton(btn, info) {
        this.AddEntity()
    }

    OnEditButton(btn, info) {
        selected := this.guiObj["ListView"].GetNext(, "Focused")

        if (selected > 0) {
            key := this.guiObj["ListView"].GetText(selected, 1)
            this.EditEntity(key)
        }
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

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("y", ["AddButton"])
    }

    GetContextMenuItems() {
        definition := this.entityType.definition
        menuItems := []

        if (definition["allow_view"]) {
            menuItems.Push(Map("label", "&View", "name", "ViewEntity"))
        }

        if (definition["allow_edit"]) {
            menuItems.Push(Map("label", "Edit", "name", "EditEntity"))
        }

        if (definition["allow_delete"]) {
            menuItems.Push(Map("label", "Delete", "name", "DeleteEntity"))
        }

        return menuItems
    }

    ShowListViewContextMenu(lv, item, isRightClick, X, Y) {
        key := this.listView.GetRowKey(item)
        entityObj := this.entityMgr[key]

        menuItems := this.GetContextMenuItems()
        result := this.app.Service("manager.gui").Menu(menuItems, this)
        this.ProcessContextMenuResult(result, key)
    }

    ProcessContextMenuResult(result, key) {
        if (result == "ViewEntity") {
            this.EditEntity(key)
        } else if (result == "EditEntity") {
            this.EditEntity(key)
        } else if (result == "DeleteEntity") {
            this.DeleteEntity(key)
        }
    }
}
