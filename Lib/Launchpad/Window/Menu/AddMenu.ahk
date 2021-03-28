class AddMenu extends MenuGui {
    buttonsPerRow := 1
    menuTitle := "Add Game"

    __New(app, themeObj, windowKey, owner := "", parent := "") {
        if (owner == "") {
            owner := "ManageWindow" 
        }

        super.__New(app, themeObj, windowKey, "", "", owner, parent)
    }

    Controls() {
        super.Controls()
        this.AddMenuButton("&Add Game", "AddGame")
        this.AddMenuButton("&Import Shortcut", "ImportShortcut")
        this.AddMenuButton("&Detect Games", "DetectGames")
    }

    OnDetectGames(btn, info) {
        this.Close()
        this.app.Platforms.DetectGames()
    }

    OnImportShortcut(btn, info) {
        this.Close()

        if (this.app.GuiManager.WindowExists("ManageWindow")) {
            this.app.GuiManager.GetWindow("ManageWindow").ImportShortcut()
        }
    }

    OnAddGame(btn, info) {
        this.Close()
        
        if (this.app.GuiManager.WindowExists("ManageWindow")) {
            this.app.GuiManager.GetWindow("ManageWindow").AddLauncher()
        }
    }
}
