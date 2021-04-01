class MenuGui extends GuiBase {
    positionAtMouseCursor := true
    nextPos := "x" . this.margin
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

    __New(app, themeObj, windowKey, menuItems := "", parent := "", openAtCtl := "", openAtCtlSide := "") {
        if (menuItems == "") {
            menuItems := []
        }

        if (parent) {
            parent := app.GuiManager.DereferenceGui(parent)

            if (parent.HasBase(MenuGui.Prototype)) {
                this.parentMenu := parent
            }
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

        super.__New(app, themeObj, windowKey, this.menuTitle, "", parent)
    }

    OnLButton(hotKey) {
        if (!this.childOpen) {
            MouseGetPos(,, mouseWindow)
            
            if (this.guiObj && this.guiObj.Hwnd != mouseWindow) {
                this.canceled := true
            }
        }
    }

    Show() {
        Hotkey("~LButton", this.onLButtonCallback, "On")
        return super.Show()
    }

    Destroy() {
        Hotkey("~LButton", this.onLButtonCallback, "Off")
        super.Destroy()
    }

    Controls() {
        super.Controls()
        this.nextPos := "x" . this.margin
        
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
        buttonSpacing := this.windowSettings["spacing"]["buttonSpacing"]
        marginSpace := (buttonSpacing * this.buttonsPerRow) - buttonSpacing
        width := (this.windowSettings["contentWidth"] - marginSpace) / this.buttonsPerRow

        buttonSize := this.themeObj.GetButtonSize("menu")
        buttonH := (buttonSize.Has("h") && buttonSize["h"] != "auto") ? buttonSize["h"] : this.buttonHeight

        handler := childItems ? "ParentItemClick" : "MenuItemClick"
        btn := this.AddButton("v" . ctlName . " " . this.nextPos . " w" . width . " h" . buttonH, buttonLabel, handler, "menu")
        btn.Menu := this
        btn.ChildItems := childItems

        if (this.buttonsPerRow > 1) {
            this.nextPos := this.nextPos == "x" . this.margin ? "x+" . buttonSpacing . " yp" : "x" . this.margin
        }

        return btn
    }

    AddMenuSeparator() {
        buttonSpacing := this.windowSettings["spacing"]["buttonSpacing"]
        marginSpace := (buttonSpacing * this.buttonsPerRow) - buttonSpacing
        width := (this.windowSettings["contentWidth"] - marginSpace) / this.buttonsPerRow
        btn := this.AddButton(this.nextPos . " w" . width . " h" . this.separatorHeight, "", "OnSeparator", "menuSeparator")

        if (this.buttonsPerRow > 1) {
            this.nextPos := this.nextPos == "x" . this.margin ? "x+" . buttonSpacing . " yp" : "x" . this.margin
        }
    }

    MenuItemClick(btn, info) {
        this.result := btn.Name
    }

    ParentItemClick(btn, info) {
        result := ""

        if (btn.ChildItems) {
            this.childOpen := true
            this.result := this.app.GuiManager.Menu("MenuGui", btn.ChildItems, this, btn, "right")
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
