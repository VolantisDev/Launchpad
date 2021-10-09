class GuiManager extends ContainerServiceBase {
    app := ""
    discoverEvent := Events.WINDOWS_DISCOVER
    discoverAlterEvent := Events.WINDOWS_DISCOVER_ALTER
    loadEvent := Events.WINDOW_LOAD
    loadAlterEvent := Events.WINDOW_LOAD_ALTER
    themeManagerObj := ""
    idGeneratorObj := ""
    stateObj := ""

    parents := Map()
    children := Map()
    locked := Map()
    menus := Map()

    __New(app, themeManagerObj, idGeneratorObj, stateObj, defaultComponentInfo := "", defaultComponents := "", autoLoad := true) {
        this.app := app
        this.themeManagerObj := themeManagerObj
        this.idGeneratorObj := idGeneratorObj
        this.stateObj := stateObj
        super.__New(defaultComponentInfo, defaultComponents, autoLoad)
    }

    GetTheme() {
        return this.themeManagerObj.GetItem()
    }

    Dialog(className, params*) {
        dialogId := this.idGeneratorObj.Generate()
        window := %className%(this.app, this.GetTheme(), dialogId, params*)
        this.container.Set(dialogId, window)
        ownerKey := ""

        if (window.owner) {
            ownerKey := this.GetWindowKeyFromGui(ownerKey)

            if (ownerKey) {
                this.AddToParent(dialogId, ownerKey)
            }
        }

        result := window.Show()

        if (ownerKey) {
            this.ReleaseFromParent(dialogId)
        }
        
        this.container.Delete(dialogId)
        return result
    }

    Form(className, params*) {
        return this.Dialog(className, params*)
    }

    Menu(className, params*) {
        key := this.idGeneratorObj.Generate()
        window := %className%(this.app, this.GetTheme(), key, params*)
        this.menus[key] := window
        result := window.Show()

        if (this.menus.Has(key)) {
            this.menus.Delete(key)
        }
        
        return result
    }

    CloseMenus(menuToKeepOpen := "") {
        keepMenu := ""

        if (menuToKeepOpen && this.menus.Has(menuToKeepOpen)) {
            keepMenu := this.menus[menuToKeepOpen]
        }

        for index, window in this.menus {
            if (window.windowKey != menuToKeepOpen) {
                window.Close()
            }
        }

        newMenus := Map()

        if (keepMenu) {
            newMenus.Push(keepMenu)
        }

        this.menus := newMenus
    }

    OpenWindow(key, className := "", params*) {
        if (className == "") {
            className := key
        }

        if (!this.container.Has(key)) {
            guiObj := %className%(this.app, this.GetTheme(), key, params*)
            guiObj.Show(this.GetWindowState(key))
            this.container.Set(key, guiObj)
        }

        return this.container.Has(key) ? this.container.Get(key) : ""
    }

    CloseWindow(key) {
        if (this.container.Has(key)) {
            this.container.Get(key).Close()
            this.container.Delete(key)
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

    AddToParent(key, parentKey) {
        if (HasBase(parentKey, Gui.Prototype)) {
            parentKey := this.GetWindowKeyFromGui(parentKey)
        }

        if (this.container.Has(parentKey)) {
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
        if (!this.locked.Has(key) && this.container.Has(key)) {
            this.container.Get(key).guiObj.Opt("Disabled")
            this.locked[key] := true
        }
    }

    UnlockWindow(key, forceActivation := true) {
        if (this.locked.Has(key) && this.locked[key]) {
            windowGui := this.container.Get(key).guiObj
            windowGui.Opt("-Disabled")

            if (forceActivation) {
                WinActivate("ahk_id " . windowGui.Hwnd)
            }
            
            this.locked.Delete(key)
        }
    }

    WindowExists(key) {
        return this.container.Has(key)
    }

    GetWindow(key) {
        window := ""

        try {
            window := this.container.Get(key)
        } catch Any {

        }

        return window
    }

    GetWindowFromHwnd(hwnd) {
        windowObj := false

        for key, window in this.container.Items {
            if (window && window.guiObj && window.guiObj.Hwnd == hwnd) {
                windowObj := window
                break
            }
        }

        return windowObj
    }

    GetWindowFromGui(guiObj) {
        windowObj := false

        for key, window in this.container.Items {
            if (window && window.guiObj && window.guiObj == guiObj) {
                windowObj := window
                break
            }
        }

        return windowObj
    }

    GetWindowKeyFromGui(guiObj) {
        windowKey := false

        for key, window in this.container.Items {
            if (window && window.guiObj && window.guiObj == guiObj) {
                windowKey := key
                break
            }
        }

        return windowKey
    }

    GuiExists(hwnd) {
        return !!(this.GetWindowFromHwnd(hwnd))
    }

    DereferenceGui(obj) {
        guiObj := ""
        objType := Type(obj)

        if (obj.HasBase(Gui.Prototype)) {
            guiObj := obj
        } else if (objType == "String") {
            window := this.GetWindow(obj)
            
            if (window) {
                guiObj := window.guiObj
            }
        } else if (obj.HasBase(GuiBase.Prototype) || obj.HasProp("guiObj")) {
            guiObj := obj.guiObj
        }

        return guiObj
    }

    StoreWindowState(guiObj) {
        guiObj.guiObj.GetPos(&x, &y, &w, &h)
        windowState := Map("x", x, "y", y, "w", w, "h", h)
        this.stateObj.StoreWindowState(guiObj.windowKey, windowState)
    }

    GetWindowState(windowKey) {
        return this.stateObj.RetrieveWindowState(windowKey)
    }

    RestoreWindowState(guiObj) {
        windowState := this.GetWindowState(guiObj.windowKey)

        if (windowState && windowState.Count > 0) {
            x := windowState.Has("x") ? windowState["x"] : ""
            y := windowState.Has("y") ? windowState["y"] : ""
            w := windowState.Has("w") ? windowState["w"] : ""
            h := windowState.Has("h") ? windowState["h"] : ""

            guiObj.guiObj.Move(x, y, w, h)
        }
    }
}
