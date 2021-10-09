class MenuGui extends GuiBase {
    positionAtMouseCursor := true
    showTitlebar := false
    buttonsPerRow := 1
    menuTitle := "Menu"
    windowSettingsKey := "Menu"
    buttonHeight := 25
    separatorHeight := 5
    menuItems := ""
    showOptions := "NoActivate"
    parentMenu := ""
    waitForResult := true
    childOpen := false

    __New(app, themeObj, guiId, menuItems := "", parent := "", openAtCtl := "", openAtCtlSide := "", isChild := false) {
        if (menuItems == "") {
            menuItems := []
        }

        if (parent) {
            parent := app.Service("GuiManager").DereferenceGui(parent)

            if (parent.HasBase(MenuGui.Prototype)) {
                this.parentMenu := parent
            }
        }

        if (!isChild) {
            app.Service("GuiManager").CloseMenus(guiId)
        }

        this.menuItems := menuItems
        this.onLButtonCallback := ObjBindMethod(this, "OnLButton")

        if (openAtCtl) {
            this.openAtCtl := openAtCtl
            this.positionAtMouseCursor := false
        }

        if (openAtCtlSide) {
            this.openAtCtlSide := openAtCtlSide
        }

        super.__New(app, themeObj, guiId, this.menuTitle, "", parent)
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
            this.result := this.app.Service("GuiManager").Menu("MenuGui", btn.ChildItems, this, btn, "right", true)
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
