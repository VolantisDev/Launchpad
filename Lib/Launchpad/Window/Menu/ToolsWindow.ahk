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
        this.AddMenuButton("&Manage Platforms", "ManagePlatforms")
        this.AddMenuButton("Manage &Backups", "ManageBackups")
        this.AddMenuButton("&Reload Launchers", "ReloadLaunchers")
        this.AddMenuButton("&Clean Launchers", "CleanLaunchers")
        this.AddMenuButton("&Flush Cache", "FlushCache")
        this.AddMenuButton("&Update Launchpad", "CheckForUpdates")
        this.AddMenuButton("&Open Website", "OpenWebsite")
        this.AddMenuButton("Provide &Feedback", "ProvideFeedback")
        this.AddMenuButton("&About Launchpad", "AboutLaunchpad")
    }

    OnManagePlatforms(btn, info) {
        this.Close()
        this.app.GuiManager.OpenWindow("PlatformsWindow")
    }

    OnManageBackups(btn, info) {
        this.Close()
        this.app.GuiManager.OpenWindow("ManageBackupsWindow")
    }

    OnReloadLaunchers(btn, info) {
        this.Close()
        this.app.Launchers.LoadComponents(this.app.Config.LauncherFile)

        if (this.app.GuiManager.WindowExists("ManageWindow")) {
            this.app.GuiManager.GetWindow("ManageWindow").PopulateListView()
        }
    }

    OnCleanLaunchers(btn, info) {
        this.Close()
        this.app.Builders.CleanLaunchers()
    }

    OnFlushCache(btn, info) {
        this.Close()
        this.app.Cache.FlushCaches()
    }

    OnCheckForUpdates(btn, info) {
        this.Close()
        this.app.CheckForUpdates()
    }

    OnOpenWebsite(btn, info) {
        this.Close()
        this.app.OpenWebsite()
    }

    OnProvideFeedback(btn, info) {
        this.Close()
        this.app.ProvideFeedback()
    }

    OnAboutLaunchpad(btn, info) {
        this.Close()
        this.app.GuiManager.Dialog("AboutWindow")
    }
}
