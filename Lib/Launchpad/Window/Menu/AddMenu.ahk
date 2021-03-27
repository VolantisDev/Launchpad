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
        this.AddMenuButton("&Add a Game", "AddGame")
        this.AddMenuButton("&Detect Games", "DetectGames")
    }

    OnDetectGames(btn, info) {
        this.Close()
        this.app.Platforms.DetectGames()
    }

    OnAddGame(btn, info) {
        this.Close()
        
        if (this.app.GuiManager.WindowExists("ManageWindow")) {
            this.app.GuiManager.GetWindow("ManageWindow").AddLauncher()
        }
    }
}
