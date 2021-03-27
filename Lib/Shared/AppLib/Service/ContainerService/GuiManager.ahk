class GuiManager extends ContainerServiceBase {
    registerEvent := Events.WINDOWS_REGISTER
    alterEvent := Events.WINDOWS_ALTER

    parents := Map()
    children := Map()
    locked := Map()

    GetTheme() {
        return this.app.Themes.GetItem()
    }

    Dialog(className, params*) {
        dialogId := this.app.IdGen.Generate()
        window := %className%.new(this.app, this.GetTheme(), dialogId, params*)
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
        return this.OpenWindow(className, className, params*)
    }

    OpenWindow(key, className := "", params*) {
        if (className == "") {
            className := key
        }

        if (!this.container.Exists(key)) {
            guiObj := %className%.new(this.app, this.GetTheme(), key, params*)
            guiObj.Show()
            this.container.Set(key, guiObj)
        }

        return this.container.Exists(key) ? this.container.Get(key) : ""
    }

    CloseWindow(key) {
        if (this.container.Exists(key)) {
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

        if (this.container.Exists(parentKey)) {
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
        if (!this.locked.Has(key) && this.container.Exists(key)) {
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
        return this.container.Exists(key)
    }

    GetWindow(key) {
        window := ""

        try {
            window := this.container.Get(key)
        } catch e {

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
}
