class ToolsWindow extends MenuGui {
    buttonsPerRow := 2
    menuTitle := "Tools"

    Controls() {
        super.Controls()
        this.AddMenuButton("&Detect Games", "DetectGames")
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
        this.app.Windows.OpenPlatformsWindow()
    }

    OnManageBackups(btn, info) {
        this.Close()
        this.app.Windows.OpenManageBackupsWindow()
    }

    OnDetectGames(btn, info) {
        this.Close()
        this.app.Platforms.DetectGames()
    }

    OnReloadLaunchers(btn, info) {
        this.Close()
        this.app.Launchers.LoadComponents(this.app.Config.LauncherFile)

        if (this.app.Windows.WindowIsOpen("ManageWindow")) {
            this.app.Windows.GetItem("ManageWindow").PopulateListView()
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

    OnClose(guiObj) {
        this.Close()
        super.OnClose(guiObj)
    }

    OnEscape(guiObj) {
        this.Close()
        super.OnEscape(guiObj)
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
        this.app.Windows.AboutWindow()
    }
}
