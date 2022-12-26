class GuiManager extends ComponentManagerBase {
    factory := ""
    stateObj := ""

    parents := Map()
    children := Map()
    locked := Map()
    menus := Map()

    __New(container, factory, stateObj, eventMgr, notifierObj) {
        this.factory := factory
        this.stateObj := stateObj
        super.__New(container, "gui.", eventMgr, notifierObj, GuiBase)
    }

    GetDefaultComponentId() {
        return this.container.Get("config.app")["main_window"]
    }

    GetWindow(config, params*) {
        config := this.factory.GetGuiConfig(config, params*)

        if (!config["id"] || !this.Has(config["id"])) {
            this.CreateWindow(config, params*)
        }

        if (config["ownerOrParent"]) {
            this.AddToParent(config["id"], config["ownerOrParent"])
        }

        return this[config["id"]]
    }

    /*
        config can be just an id if the window is known already, or it should be a full config map if it's custom
    */
    OpenWindow(config, params*) {
        guiId := this.factory.GetGuiId(config, params*)
        windowState := this.GetWindowState(guiId)
        return this.GetWindow(config, params*).Show(windowState)
    }

    CreateWindow(config, params*) {
        guiId := this.factory.GetGuiId(config, params*)
        arguments := [config]

        for index, param in params {
            arguments.Push(param)
        }

        this[guiId] := Map(
            "factory", this.factory,
            "method", "CreateGui",
            "arguments", arguments
        )

        return guiId
    }

    CleanupWindow(guiId, deleteDefinition := true) {
        if (this.Has(guiId)) {
            this.ReleaseFromParent(guiId)
            this.CloseChildren(guiId, deleteDefinition)
            this.UnloadComponent(guiId, deleteDefinition)
        }
    }

    Dialog(config, params*) {
        if (!config) {
            config := Map()
        }

        if (Type(config) == "String") {
            config := Map("text", config)
        }

        if (!config.Has("type") || !config["type"]) {
            config["type"] := "DialogBox"
        }

        if (!config.Has("unique")) {
            config["unique"] := true
        }

        if (!config.Has("waitForResult")) {
            config["waitForResult"] := true
        }

        if (!config.Has("alwaysOnTop")) {
            config["alwaysOnTop"] := true
        }

        config["id"] := this.factory.GetGuiId(config, params*)

        window := this.GetWindow(config, params*)
        result := window.Show()
        this.CleanupWindow(config["id"], true)
        return result
    }

    /*
        As a shortcut, config can be the array of menu items.
        In this case, menuItems can be the parent Gui or Gui ID

        This will resolve to Map("type", "MenuGui", "ownerOrParent", parent, "child", true)
    */
    Menu(config, menuItems := "", openAtCtl := "", params*) {
        if (HasBase(config, Array.Prototype)) {
            parent := menuItems ? menuItems : ""
            menuItems := config
            config := Map(
                "type", "MenuGui",
                "ownerOrParent", parent,
                "child", !!(parent),
                "unique", true
            )
        }

        if (!config) {
            config := Map("type", "MenuGui")
        } else if (Type(config) == "String") {
            config := Map("type", config)
        } else if (!config.Has("type") || !config["type"]) {
            config["type"] := "MenuGui"
        }

        if (!config.Has("unique")) {
            config["unique"] := true
        }

        guiId := this.CreateWindow(config, menuItems, openAtCtl, params*)
        this.menus[guiId] := this[guiId]

        result := this.menus[guiId].Show()
        this.CleanupWindow(guiId, true)

        if (this.menus.Has(guiId)) {
            this.menus.Delete(guiId)
        }
        
        return result
    }

    CloseMenus(menuToKeepOpen := "") {
        keepMenu := ""

        if (menuToKeepOpen && this.menus.Has(menuToKeepOpen)) {
            keepMenu := this.menus[menuToKeepOpen].guiId
        }

        for index, window in this.menus {
            if (window.guiId != menuToKeepOpen) {
                window.Close()
            }
        }

        newMenus := Map()

        if (keepMenu) {
            newMenus[menuToKeepOpen] := keepMenu
        }

        this.menus := newMenus
    }

    CloseChildren(key, deleteDefinitions := false) {
        if (this.children.Has(key)) {
            for index, childKey in this.children[key] {
                this.get[childKey].Close()
            }
        }
    }

    ReleaseFromParent(key) {
        if (this.parents.Has(key)) {
            parentKey := this.parents[key]

            if (this.children.Has(parentKey)) {
                newChildren := []

                for index, childKey in this.children[parentKey] {
                    if (childKey != key) {
                        newChildren.Push(childKey)
                    }
                }

                if (newChildren.Length == 0) {
                    this.children.Delete(parentKey)
                    this.UnlockWindow(parentKey)
                } else {
                    this.children[parentKey] := newChildren
                }
            }

            this.parents.Delete(key)
        }
    }

    AddToParent(key, parentKey) {
        if (this.Has(parentKey)) {
            if (!this.children.Has(parentKey)) {
                this.children[parentKey] := []
            }

            this.children[parentKey].Push(key)

            if (!this.parents.Has(key)) {
                this.parents[key] := []
            }

            this.parents[key] := parentKey
            this.LockWindow(parentKey)
        }
    }

    LockWindow(key) {
        if (!this.locked.Has(key) && this.Has(key)) {
            this[key].guiObj.Opt("Disabled")
            this.locked[key] := true
        }
    }

    UnlockWindow(key, forceActivation := true) {
        if (this.locked.Has(key) && this.locked[key]) {
            windowGui := this[key].guiObj
            windowGui.Opt("-Disabled")

            if (forceActivation) {
                WinActivate("ahk_id " . windowGui.Hwnd)
            }
            
            this.locked.Delete(key)
        }
    }

    GetWindowFromHwnd(hwnd, ignoreFailure := false) {
        windowObj := ""

        for key, window in this.All() {
            if (window && window.guiObj && window.guiObj.Hwnd == hwnd) {
                windowObj := window
                break
            }
        }

        if (!windowObj && !ignoreFailure) {
            throw ComponentException("Window with Hwnd " . hwnd . " not found")
        }

        return windowObj
    }

    GetWindowFromGui(guiObj, ignoreFailure := false) {
        windowObj := ""

        for key, window in this.All() {
            if (window && window.guiObj && window.guiObj == guiObj) {
                windowObj := window
                break
            }
        }

        if (!windowObj && !ignoreFailure) {
            throw ComponentException("Window for provided gui not found")
        }

        return windowObj
    }

    GuiExists(hwnd) {
        return !!(this.GetWindowFromHwnd(hwnd, true))
    }

    DereferenceGui(obj) {
        guiObj := ""

        if (HasBase(obj, Gui.Prototype)) {
            guiObj := obj
        } else if (HasBase(obj, GuiBase.Prototype)) {
            guiObj := obj.guiObj
        } else if (Type(obj) == "String" && this.Has(obj)) {
            guiObj := this[obj].guiObj
        }

        return guiObj
    }

    StoreWindowState(guiObj) {
        guiObj.guiObj.GetPos(&x, &y, &w, &h)
        windowState := Map("x", x, "y", y, "w", w, "h", h)
        this.stateObj.StoreWindowState(guiObj.guiId, windowState)
    }

    GetWindowState(guiId) {
        return this.stateObj.RetrieveWindowState(guiId)
    }

    RestoreWindowState(guiObj) {
        windowState := this.GetWindowState(guiObj.guiId)

        if (windowState && windowState.Count > 0) {
            x := windowState.Has("x") ? windowState["x"] : ""
            y := windowState.Has("y") ? windowState["y"] : ""
            w := windowState.Has("w") ? windowState["w"] : ""
            h := windowState.Has("h") ? windowState["h"] : ""

            guiObj.guiObj.Move(x, y, w, h)
        }
    }
}
