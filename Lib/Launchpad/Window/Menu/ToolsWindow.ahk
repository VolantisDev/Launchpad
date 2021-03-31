class ToolsWindow extends MenuGui {
    buttonsPerRow := 1
    menuTitle := "Tools"

    __New(app, themeObj, windowKey, owner := "", parent := "") {
        if (owner == "") {
            owner := "ManageWindow" 
        }

        super.__New(app, themeObj, windowKey, "", "", owner, parent)
    }

    Controls() {
        super.Controls()
        this.AddMenuButton("Manage &Platforms", "ManagePlatforms")
        this.AddMenuButton("Manage &Backups", "ManageBackups")
        this.AddMenuButton("&Clean Launchers", "CleanLaunchers")
        this.AddMenuButton("&Reload Launchers", "ReloadLaunchers")
        this.AddMenuButton("Provide &Feedback", "ProvideFeedback")
    }

    OnManagePlatforms(btn, info) {
        this.Close()
        this.app.GuiManager.OpenWindow("PlatformsWindow")
    }

    OnManageBackups(btn, info) {
        this.Close()
        this.app.GuiManager.OpenWindow("ManageBackupsWindow")
    }

    OnProvideFeedback(btn, info) {
        this.Close()
        this.app.ProvideFeedback()
    }

    OnCleanLaunchers(btn, info) {
        this.Close()
        this.app.Builders.CleanLaunchers()
    }

    OnReloadLaunchers(btn, info) {
        this.Close()
        this.app.Launchers.LoadComponents(this.app.Config.LauncherFile)

        if (this.app.GuiManager.WindowExists("ManageWindow")) {
            this.app.GuiManager.GetWindow("ManageWindow").PopulateListView()
        }
    }
}
