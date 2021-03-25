class AddMenu extends MenuGui {
    buttonsPerRow := 1
    menuTitle := "Add Game"

    Controls() {
        super.Controls()
        this.AddMenuButton("&Detect Games", "DetectGames")
        this.AddMenuButton("&Add a game", "AddGame")
    }

    OnDetectGames(btn, info) {
        this.Close()
        this.app.Platforms.DetectGames()
    }

    OnAddGame(btn, info) {
        this.Close()
        this.app.Windows.GetItem("ManageWindow").AddLauncher()
    }
}
