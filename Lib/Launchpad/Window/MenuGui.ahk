﻿class MenuGui extends LaunchpadGuiBase {
    positionAtMouseCursor := true
    nextPos := "x" . this.margin
    showTitlebar := false
    buttonsPerRow := 1
    menuTitle := "Menu"
    buttonHeight := 25

    __New(app, windowKey := "", owner := "", parent := "") {
        super.__New(app, this.menuTitle, windowKey, owner, parent)
        this.onLButtonCallback := ObjBindMethod(this, "OnLButton")
    }

    OnLButton(hotKey) {
        if (this.app && this.app.Windows && this.app.Windows.WindowIsOpen(this.windowKey)) {
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
        this.nextPos := "x" . this.margin
        super.Controls()
    }

    AddMenuButton(buttonLabel, ctlName) {
        buttonSpacing := this.windowSettings["spacing"]["buttonSpacing"]
        marginSpace := (buttonSpacing * this.buttonsPerRow) - buttonSpacing
        width := (this.windowSettings["contentWidth"] - marginSpace) / this.buttonsPerRow

        buttonSize := this.themeObj.GetButtonSize("menu")
        buttonH := (buttonSize.Has("h") && buttonSize["h"] != "auto") ? buttonSize["h"] : this.buttonHeight

        btn := this.AddButton("v" . ctlName . " " . this.nextPos . " w" . width . " h" . buttonH, buttonLabel, "", "menu")

        if (this.buttonsPerRow > 1) {
            this.nextPos := this.nextPos == "x" . this.margin ? "x+" . buttonSpacing . " yp" : "x" . this.margin
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
