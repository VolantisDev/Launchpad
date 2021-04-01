class MenuGui extends GuiBase {
    positionAtMouseCursor := true
    nextPos := "x" . this.margin
    showTitlebar := false
    buttonsPerRow := 1
    menuTitle := "Menu"
    windowSettingsKey := "Menu"
    buttonHeight := 25
    menuItems := ""
    menuEventSync := ""
    showOptions := "NoActivate"
    parentMenu := ""

    __New(app, themeObj, windowKey, menuItems := "", menuEventSync := "", owner := "", parentMenu := "", openAtCtl := "", openAtCtlSide := "") {
        if (menuItems == "") {
            menuItems := []
        }

        this.parentMenu := parentMenu
        this.menuEventSync := menuEventSync
        this.menuItems := menuItems
        this.onLButtonCallback := ObjBindMethod(this, "OnLButton")

        if (openAtCtl) {
            this.openAtCtl := openAtCtl
            this.positionAtMouseCursor := false
        }

        if (openAtCtlSide) {
            this.openAtCtlSide := openAtCtlSide
        }

        super.__New(app, themeObj, windowKey, this.menuTitle, owner, "")
    }

    OnLButton(hotKey) {
        if (this.app && this.app.GuiManager && this.app.GuiManager.WindowExists(this.windowKey)) {
            MouseGetPos(,, mouseWindow)
            
            if (this.guiObj && this.guiObj.Hwnd != mouseWindow) {
                this.Close()
            }
        }
    }

    Show() {
        Hotkey("~LButton", this.onLButtonCallback, "On")
        super.Show()
    }

    Destroy() {
        Hotkey("~LButton", this.onLButtonCallback, "Off")
        super.Destroy()
    }

    Controls() {
        super.Controls()
        this.nextPos := "x" . this.margin
        
        for index, item in this.menuItems {
            if (!item.Has("childItems")) {
                item["childItems"] := ""
            }

            this.AddMenuButton(item["label"], item["name"], item["childItems"])
        }
    }

    AddMenuButton(buttonLabel, ctlName, childItems := "") {
        buttonSpacing := this.windowSettings["spacing"]["buttonSpacing"]
        marginSpace := (buttonSpacing * this.buttonsPerRow) - buttonSpacing
        width := (this.windowSettings["contentWidth"] - marginSpace) / this.buttonsPerRow

        buttonSize := this.themeObj.GetButtonSize("menu")
        buttonH := (buttonSize.Has("h") && buttonSize["h"] != "auto") ? buttonSize["h"] : this.buttonHeight

        handler := childItems ? "ParentItemClick" : (this.menuEventSync ? "MenuItemClick" : "")
        btn := this.AddButton("v" . ctlName . " " . this.nextPos . " w" . width . " h" . buttonH, buttonLabel, handler, "menu")
        btn.Menu := this
        btn.ChildItems := childItems

        if (this.buttonsPerRow > 1) {
            this.nextPos := this.nextPos == "x" . this.margin ? "x+" . buttonSpacing . " yp" : "x" . this.margin
        }

        return btn
    }

    MenuItemClick(btn, info) {
        sync := this.menuEventSync
        functionName := "On" . btn.Name
        this.Close()
        
        if (sync) {
            sync.%functionName%(btn, info)
        }
    }

    ParentItemClick(btn, info) {
        if (btn.ChildItems) {
            childItems := btn.ChildItems
            sync := this.menuEventSync
            owner := this.owner
            this.app.GuiManager.Menu("MenuGui", ChildItems, sync, owner, this, btn, "right")
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

    Close() {
        parentMenu := this.parentMenu
        super.Close()
        
        if (parentMenu) {
            parentMenu.Close()
        }
    }
}
