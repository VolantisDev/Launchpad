class GuiManager extends ComponentManagerBase {
    app := ""
    factory := ""
    stateObj := ""

    parents := Map()
    children := Map()
    locked := Map()
    menus := Map()

    __New(container, factory, stateObj, eventMgr, notifierObj) {
        this.app := container.GetApp()
        this.factory := factory
        this.stateObj := stateObj

        super.__New(
            container, 
            "gui.",
            eventMgr,
            notifierObj,
            GuiBase
        )
    }

    Dialog(className, params*) {
        guiId := this.factory.CreateGuiId(className, params*)
        this[guiId] := this.factory.CreateServiceDefinition(className, guiId, params*)
        window := this[window.guiId]

        ownerKey := ""

        if (window.owner) {
            ownerKey := this.GetWindowKeyFromGui(ownerKey, true)

            if (ownerKey) {
                this.AddToParent(guiId, ownerKey)
            }
        }

        result := window.Show()

        if (ownerKey) {
            this.ReleaseFromParent(guiId)
        }

        this.UnloadComponent(guiId)
        return result
    }

    Menu(className, params*) {
        guiId := this.factory.CreateGuiId(className, params*)
        this.menus[guiId] := this.factory.CreateServiceDefinition(className, guiId, params*)

        result := this.menus[guiId].Show()

        if (this.menus.Has(guiId)) {
            this.menus.Delete(guiId)
        }
        
        return result
    }

    CloseMenus(menuToKeepOpen := "") {
        keepMenu := ""

        if (menuToKeepOpen && this.menus.Has(menuToKeepOpen)) {
            keepMenu := this.menus[menuToKeepOpen]
        }

        for index, window in this.menus {
            if (window.guiId != menuToKeepOpen) {
                window.Close()
            }
        }

        newMenus := []

        if (keepMenu) {
            newMenus.Push(keepMenu)
        }

        this.menus := newMenus
    }

    OpenWindow(key, className := "", params*) {
        if (className == "") {
            className := key
        }

        if (!this.Has(key)) {
            this[key] := this.factory.CreateServiceDefinition(className, key, params*)
        }

        if (!this.Has(key)) {
            throw ComponentException("Window " . key . " could not be opened")
        }

        return this[key].Show(this.GetWindowState(key))
    }

    CloseWindow(key) {
        if (this.Has(key)) {
            this[key].Close()
            this.UnloadComponent(key)
        }
    }

    CloseChildren(key) {
        if (this.children.Has(key)) {
            for index, childKey in this.children[key] {
                this.CloseWindow(childKey)
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

    AddToParent(key, parentKeyOrGuiObj) {
        if (parentKey.HasBase(Gui.Prototype)) {
            parentKey := this.GetWindowKeyFromGui(parentKey)
        }

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

    GetWindowKeyFromGui(guiObj, ignoreFailure := false) {
        guiId := ""

        for key, window in this.All() {
            if (window && window.guiObj && window.guiObj == guiObj) {
                guiId := key
                break
            }
        }

        if (!guiId && !ignoreFailure) {
            throw ComponentException("Window not found from provided GUI object")
        }

        return guiId
    }

    GuiExists(hwnd) {
        return !!(this.GetWindowFromHwnd(hwnd, true))
    }

    DereferenceGui(obj) {
        guiObj := obj
        objType := Type(guiObj)

        if (!obj.HasBase(Gui.Prototype)) {
            if (objType == "String" && this.Has(obj)) {
                guiObj := this[obj].guiObj
            } else if (obj.HasBase(GuiBase.Prototype)) {
                guiObj := obj.guiObj
            }
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
