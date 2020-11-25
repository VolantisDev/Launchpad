class SettingsWindow extends WindowBase {
    windowOptions := "-MaximizeBox -SysMenu"
    contentWidth := 400

    __New(app, owner := "", windowKey := "") {
        super.__New(app, "Settings", owner, windowKey)
    }

    Controls() {
        super.Controls()
        
        groupW := this.contentWidth - (this.margin * 2)
        openX := groupW - (this.buttonSmallW * 2) ; this assumes the group starts at this.margin

        tabs := this.guiObj.Add("Tab3", "h" . this.tabHeight . " +0x100", ["Launchers", "Assets", "Sources", "Advanced"])

        tabs.UseTab("Launchers", true)


        this.AddHeading("Launcher File")
        this.AddConfigLocationBlock("LauncherFile", "Reload")

        this.AddHeading("Launcher Directory")
        this.AddConfigLocationBlock("LauncherDir")

        this.AddHeading("Launcher Settings")
        this.AddConfigCheckBox("Create individual launcher directories", "IndividualDirs")
        this.AddConfigCheckBox("Update existing launchers on build", "UpdateExistingLaunchers")
        this.AddConfigCheckBox("Clean launchers on build", "CleanLaunchersOnBuild")
        this.AddConfigCheckBox("Clean launchers on exit", "CleanLaunchersOnExit")

        tabs.UseTab("Assets", true)

        this.AddHeading("Assets Directory")
        this.AddConfigLocationBlock("AssetsDir")

        this.AddHeading("Asset Settings")
        this.AddConfigCheckBox("Copy assets to launcher directory", "CopyAssets")

        tabs.UseTab("Sources", true)

        this.AddHeading("API Endpoint")
        this.AddConfigLocationBlock("ApiEndpoint")

        tabs.UseTab("Advanced", true)

        this.AddHeading("Cache Dir")
        this.AddConfigLocationBlock("CacheDir", "&Flush")

        this.AddHeading("Cache Settings")
        this.AddConfigCheckBox("Flush cache on exit", "FlushCacheOnExit")

        tabs.UseTab()

        closeW := 100
        closeX := this.margin + (this.contentWidth / 2) - (closeW / 2)

        this.AddButton("&Done", "CloseButton", closeW, 30, "x" . closeX)
    }

    AddConfigLocationBlock(settingName, extraButton := "", inGroupBox := true) {
        location := this.app.Config.%settingName% ? this.app.Config.%settingName% : "Not selected"

        this.AddLocationText(location, settingName, inGroupBox)

        position := inGroupBox ? "xs+" . this.margin . " y+m" : "xs y+m"
        btn := this.guiObj.AddButton(position . " w" . this.buttonSmallW . " h" . this.buttonSmallH, "Change")
        btn.OnEvent("Click", "OnChange" . settingName)

        btn := this.guiObj.AddButton("x+m yp w" . this.buttonSmallW . " h" . this.buttonSmallH, "Open")
        btn.OnEvent("Click", "OnOpen" . settingName)

        if (extraButton != "") {
            btn := this.guiObj.AddButton("x+m yp w" . this.buttonSmallW . " h" . this.buttonSmallH, extraButton)
            btn.OnEvent("Click", "On" . extraButton . settingName)
        }
    }

    AddLocationText(locationText, ctlName, inGroupBox := true) {
        position := "xs"

        if (inGroupBox) {
            position .= "+" . this.margin
        }

        position .= " y+m"

        this.guiObj.SetFont("Bold")
        this.guiObj.AddText("v" . ctlName . " " . position . " w" . this.contentWidth . " +0x200 c" . this.accentDarkColor, locationText)
        this.guiObj.SetFont()
    }

    AddConfigCheckBox(checkboxText, settingName, inGroupBox := true) {
        isChecked := this.app.Config.%settingName%
        this.AddCheckBox(checkboxText, settingName, isChecked, inGroupBox, "OnSettingsCheckBox")
    }

    OnSettingsCheckBox(chk, info) {
        this.guiObj.Submit(false)
        ctlName := chk.Name
        this.app.Config.%ctlName% := chk.Value
    }

    AddCheckBox(checkboxText, ctlName, checked, inGroupBox := true, callback := "") {
        if (callback == "") {
            callback := "On" . ctlName
        }

        width := this.contentWidth
        position := "xs"

        if (inGroupBox) {
            position .= "+" . this.margin
            width -= this.margin * 2
        }

        position .= " y+m"

        chk := this.guiObj.AddCheckBox(position . " w" . width . " v" . ctlName . " checked" . checked, checkboxText)
        chk.OnEvent("Click", callback)
    }

    AddButton(buttonLabel, ctlName, width := "", height := "", position := "xs y+m") {
        if (width == "") {
            width := this.buttonSmallW
        }

        if (height == "") {
            height := this.buttonSmallH
        }

        btn := this.guiObj.AddButton("v" . ctlName . " " . position . " w" . width . " h" . height, buttonLabel)
        btn.OnEvent("Click", "On" . ctlName)
    }

    SetText(ctlName, ctlText, fontStyle := "") {
        this.guiObj.SetFont(fontStyle)
        this.guiObj[ctlName].Text := ctlText
        this.guiObj.SetFont()
    }

    OnCloseButton(btn, info) {
        this.Close()
    }

    OnReloadLauncherFile(btn, info) {
        this.app.Launchers.ReloadLauncherFile()
    }

    OnOpenLauncherFile(btn, info) {
        this.app.Launchers.OpenLauncherFile()
    }

    OnChangeLauncherFile(btn, info) {
        this.app.Launchers.ChangeLauncherFile()
        this.SetText("LauncherFile", this.app.Config.LauncherFile, "Bold")
    }

    OnOpenLauncherDir(btn, info) {
        this.app.Launchers.OpenLauncherDir()
    }

    OnChangeLauncherDir(btn, info) {
        this.app.Launchers.ChangeLauncherDir()
        this.SetText("LauncherDir", this.app.Config.LauncherDir, "Bold")
    }

    OnOpenAssetsDir(btn, info) {
        this.app.Launchers.OpenAssetsDir()
    }

    OnChangeAssetsDir(btn, info) {
        this.app.Launchers.ChangeAssetsDir()
        this.SetText("AssetsDir", this.app.Config.AssetsDir, "Bold")
    }

    OnOpenApiEndpoint(btn, info) {
        this.app.DataSources.GetDataSource("api").Open()
    }

    OnChangeApiEndpoint(btn, info) {
        this.app.DataSources.GetDataSource("api").ChangeApiEndpoint(, "SettingsWindow")
        this.SetText("ApiEndpoint", this.app.Config.ApiEndpoint, "Bold")
    }

    OnFlushCache(btn, info) {
        this.app.Cache.FlushCaches()
    }

    OnOpenCacheDir(btn, info) {
        this.app.Cache.OpenCacheDir()
    }

    OnChangeCacheDir(btn, info) {
        this.app.Cache.ChangeCacheDir()
        this.SetText("TxtCacheDir", this.app.Config.CacheDir, "Bold")
    }
}
