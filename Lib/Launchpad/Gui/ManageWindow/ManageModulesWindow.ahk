class ManageModulesWindow extends ManageWindowBase {
    listViewColumns := Array("NAME", "ENABLED", "SOURCE", "VERSION")
    moduleManager := ""
    needsRestart := false

    __New(container, themeObj, config) {
        this.moduleManager := container.Get("manager.module")
        this.lvCount := this.moduleManager.Count(true)
        super.__New(container, themeObj, config)
    }

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["title"] := "Manage Modules"
        defaults["modules_file"] := container.Get("Config")["modules_file"]
        return defaults
    }

    AddBottomControls(y) {
        position := "x" . this.margin . " y" . y
        this.AddManageButton("AddButton", position, "add", true)
    }

    GetListViewData(lv) {
        data := Map()

        for name, module in this.moduleManager.All("", false, true) {
            enabledText := module.IsEnabled() ? "Yes" : "No"
            ; TODO Define source
            source := ""
            data[name] := [name, enabledText, source, module.GetVersion()]
        }

        return data
    }

    ShouldHighlightRow(key, data) {
        return false
    }

    GetViewMode() {
        return this.app.Config["modules_view_mode"]
    }

    GetListViewImgList(lv, large := false) {
        IL := IL_Create(this.lvCount, 1, large)
        defaultIcon := this.themeObj.GetIconPath("Module")
        iconNum := 1

        for key, module in this.moduleManager.All("", false, true) {
            iconSrc := module.GetModuleIcon()

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
        this.ConfigureModule(key)
    }

    EnableModule(key) {
        this.moduleManager.Enable(key)
        this.needsRestart := true
        this.UpdateListView()
    }

    DisableModule(key) {
        this.moduleManager.Disable(key)
        this.needsRestart := true
        this.UpdateListView()
    }

    ConfigureModule(key) {
        modified := false
        obj := this.moduleManager[key]

        ; TODO: Implement module edit operation here

        if (modified) {
            this.needsRestart := true
            this.UpdateListView()
        }
    }

    DeleteModule(key) {
        if (this.moduleManager.DeleteModule(key)) {
            this.needsRestart := true
            this.UpdateListView()
        }
    }

    OnAddButton(btn, info) {
        this.AddModule()
    }

    AddModule() {
        ; TODO: Implement module add operation
        Run("https://github.com/topics/launchpad-module")
    }

    OnSize(guiObj, minMax, width, height) {
        super.OnSize(guiObj, minMax, width, height)
        
        if (minMax == -1) {
            return
        }

        this.AutoXYWH("y", ["AddButton"])
    }

    ShowListViewContextMenu(lv, item, isRightClick, X, Y) {
        key := this.listView.GetRowKey(item)
        module := this.moduleManager[key]

        menuItems := []

        if (module.IsEnabled()) {
            menuItems.Push(Map("label", "Disable", "name", "DisableModule"))
        } else {
            menuItems.Push(Map("label", "Enable", "name", "EnableModule"))
        }

        menuItems.Push(Map("label", "Configure", "name", "ConfigureModule"))

        if (!module.IsCore()) {
            menuItems.Push(Map("label", "Delete", "name", "DeleteModule"))
        }

        result := this.app.Service("manager.gui").Menu(menuItems, this)

        if (result == "EnableModule") {
            this.EnableModule(key)
        } else if (result == "DisableModule") {
            this.DisableModule(key)
        } else if (result == "ConfigureModule") {
            this.ConfigureModule(key)
        } else if (result == "DeleteModule") {
            this.DeleteModule(key)
        }
    }
}
