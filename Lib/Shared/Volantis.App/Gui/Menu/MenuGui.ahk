class MenuGui extends GuiBase {
    buttonsPerRow := 1
    windowSettingsKey := "Menu"
    buttonHeight := 25
    separatorHeight := 5
    menuItems := ""
    showOptions := "NoActivate"
    parentMenu := ""
    childOpen := false

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["titlebar"] := false
        defaults["waitForResult"] := true
        defaults["menuTitle"] := "Menu"
        defaults["positionAtMouseCursor"] := !(this.openAtCtl)
        return defaults
    }

    __New(container, themeObj, config, menuItems := "", openAtCtl := "") {
        if (menuItems == "") {
            menuItems := []
        }

        parent := config.Has("ownerOrParent") ? config["ownerOrParent"] : ""
        isChild := config.Has("child") ? config["child"] : false

        if (parent) {
            parent := container.Get("manager.gui").DereferenceGui(parent)

            if (HasBase(parent, MenuGui.Prototype)) {
                this.parentMenu := parent
            }
        }

        if (!isChild) {
            container.Get("manager.gui").CloseMenus(config["id"])
        }

        this.menuItems := menuItems
        this.onLButtonCallback := ObjBindMethod(this, "OnLButton")

        if (openAtCtl) {
            this.openAtCtl := openAtCtl
        }

        super.__New(container, themeObj, config)
    }

    OnLButton(hotKey) {
        if (!this.childOpen) {
            MouseGetPos(,, &mouseWindow)
            
            if (this.guiObj && this.guiObj.Hwnd != mouseWindow) {
                this.canceled := true
            }
        }
    }

    Show(windowState := "") {
        Hotkey("~LButton", this.onLButtonCallback, "On")
        return super.Show(windowState)
    }

    Destroy() {
        Hotkey("~LButton", this.onLButtonCallback, "Off")
        super.Destroy()
    }

    OnSeparator(btn, info) {
        
    }

    Controls() {
        super.Controls()
        this.nextPos := "x" . this.margin

        if (!this.width) {
            widest := 0

            for index, item in this.menuItems {
                if (item && item.Has("label") && item["label"]) {
                    width := Ceil(this.themeObj.CalculateTextWidth(item["label"]))

                    if (width > widest) {
                        widest := width
                    }
                }
            }

            this.width := (widest + (this.margin*2) + 20)
        }
        
        for index, item in this.menuItems {
            if (item == "") {
                this.AddMenuSeparator()
            } else {
                if (!item.Has("childItems")) {
                    item["childItems"] := ""
                }

                this.AddMenuButton(item["label"], item["name"], item["childItems"])
            }
        }
    }

    AddMenuButton(buttonLabel, ctlName, childItems := "") {
        width := this.width ? this.width : this.windowSettings["contentWidth"]

        buttonSize := this.themeObj.GetButtonSize("menu")
        buttonH := (buttonSize.Has("h") && buttonSize["h"] != "auto") ? buttonSize["h"] : this.buttonHeight

        handler := childItems ? "ParentItemClick" : "MenuItemClick"
        btn := this.Add("ButtonControl", "v" . ctlName . " x" . this.margin . " w" . width . " h" . buttonH, buttonLabel, handler, "menu")
        btn.ctl.Menu := this
        btn.ctl.ChildItems := childItems

        return btn
    }

    AddMenuSeparator() {
        width := this.width ? this.width : this.windowSettings["contentWidth"]
        this.Add("ButtonControl", this.nextPos . " w" . width . " h" . this.separatorHeight, "", "", "menuSeparator")
    }

    MenuItemClick(btn, info) {
        this.result := btn.Name
    }

    ParentItemClick(btn, info) {
        result := ""

        if (btn.ChildItems) {
            this.childOpen := true
            this.result := this.app.Service("manager.gui").Menu(Map(
                "parent", this,
                "child", true,
                "openAtCtlSide", "right"
            ), btn.ChildItems, btn)
            this.childOpen := false
        }

        if (!result) {
            this.canceled := true
        }
    }

    OnClose(guiObj) {
        this.Close()
        super.OnClose(guiObj)
    }

    OnEscape(guiObj) {
        this.Close()
        super.OnEscape(guiObj)
    }
}
