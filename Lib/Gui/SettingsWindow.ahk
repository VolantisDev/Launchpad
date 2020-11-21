#Include GuiBase.ahk

class SettingsWindow extends GuiBase {
    windowOptions := "-MaximizeBox -SysMenu"
    windowSize := "w370"
    contentWidth := 350

    __New(app, owner := "") {
        super.__New(app, "Settings", owner)
    }

    Controls(posY) {
        posY := super.Controls(posY)
        groupX := this.margin * 2
        groupW := this.contentWidth - (this.margin * 2)
        smallButtonW := 80
        buttonRightFirstX := groupX + groupW - (smallbuttonW * 2) - this.margin
        buttonRightSecondX := buttonRightFirstX + smallButtonW + this.margin

        posY := this.AddGroupBox("Launchers", posY, 255)
        launcherFile := this.app.AppConfig.LauncherFile ? this.app.AppConfig.LauncherFile : "Not selected"
        posY := this.AddTextWithLabel("Launcher File", launcherFile, "TxtLauncherFile", posY)
        posY := this.AddButton("&Reload", "OnReloadLauncherFile", groupX, posY)
        posY := this.AddButton("Open", "OnOpenLauncherFile", buttonRightFirstX, posY)
        posY := this.AddButton("Change", "OnChangeLauncherFile", buttonRightSecondX, posY, true)
        launcherDir := this.app.AppConfig.LauncherDir ? this.app.AppConfig.LauncherDir : "Not selected"
        posY := this.AddTextWithLabel("Launcher Dir", launcherDir, "TxtLauncherDir", posY)
        posY := this.AddButton("Open", "OnOpenLauncherDir", buttonRightFirstX, posY)
        posY := this.AddButton("Change", "OnChangeLauncherDir", buttonRightSecondX, posY, true)
        posY := this.AddCheckBox("Create individual launcher directories", "ChkIndividualDirs", "OnIndividualDirs", this.app.AppConfig.IndividualDirs, posY)
        posY := this.AddCheckBox("Update existing launchers on build", "ChkUpdateExistingLaunchers", "OnUpdateExistingLaunchers", this.app.AppConfig.UpdateExistingLaunchers, posY)
        posY := this.AddCheckBox("Clean launchers on build", "ChkCleanLaunchersOnBuild", "OnCleanLaunchersOnBuild", this.app.AppConfig.CleanLaunchersOnBuild, posY)
        posY := this.AddCheckBox("Clean launchers on exit", "ChkCleanLaunchersOnExit", "OnCleanLaunchersOnExit", this.app.AppConfig.CleanLaunchersOnExit, posY)
        posY += this.margin

        posY := this.AddGroupBox("Assets", posY, 105)
        assetsDir := this.app.AppConfig.AssetsDir ? this.app.AppConfig.AssetsDir : "Not selected"
        posY := this.AddTextWithLabel("Assets Dir", assetsDir, "TxtAssetsDir", posY)
        posY := this.AddButton("Open", "OnOpenAssetsDir", buttonRightFirstX, posY)
        posY := this.AddButton("Change", "OnChangeAssetsDir", buttonRightSecondX, posY, true)
        posY := this.AddCheckBox("Copy assets to launcher directory", "ChkCopyAssets", "OnCopyAssets", this.app.AppConfig.CopyAssets, posY)
        posY += this.margin

        posY := this.AddGroupBox("API", posY, 80)
        apiEndpointVal := this.app.AppConfig.ApiEndpoint ? this.app.AppConfig.ApiEndpoint : "Not selected"
        posY := this.AddTextWithLabel("Endpoint URL", apiEndpointVal, "TxtApiEndpoint", posY)
        posY := this.AddButton("Open", "OnOpenApiEndpoint", buttonRightFirstX, posY)
        posY := this.AddButton("Change", "OnChangeApiEndpoint", buttonRightSecondX, posY, true)
        posY += this.margin

        posY := this.AddGroupBox("Cache", posY, 105)
        cacheDir := this.app.AppConfig.CacheDir ? this.app.AppConfig.CacheDir : "Not selected"
        posY := this.AddTextWithLabel("Cache Dir", cacheDir, "TxtCacheDir", posY)
        posY := this.AddButton("&Flush", "OnFlushCache", groupX, posY)
        posY := this.AddButton("Open", "OnOpenCacheDir", buttonRightFirstX, posY)
        posY := this.AddButton("Change", "OnChangeCacheDir", buttonRightSecondX, posY, true)
        posY := this.AddCheckBox("Flush cache on exit", "ChkFlushCacheOnExit", "OnFlushCacheOnExit", this.app.AppConfig.FlushCacheOnExit, posY)
        posY += this.margin

        posY := this.AddButton("&Save && Close", "OnClose", this.margin, posY, true, this.contentWidth, 30)

        return posY
    }

    AddGroupBox(groupText, posY, height) {
        this.guiObj.AddGroupBox("x" . this.margin . " y" . posY . " w" . this.contentWidth . " h" . height, groupText)
        return posY + 5 + this.margin
    }

    AddButton(buttonText, callback, posX, posY, advanceY := false, width := 80, height := 20) {
        btn := this.guiObj.AddButton("x" . posX . " y" . posY . " w" . width . " h" . height, buttonText)

        if (callback) {
            btn.OnEvent("Click", "OnReloadLauncherFile")
        }

        if (advanceY) {
            posY += height + this.margin
        }

        return posY
    }

    AddCheckBox(checkboxText, ctlName, callback, checked, posY, posX := 0, width := 0, height := 20) {
        if (posX == 0) {
            posX := this.margin * 2
        }

        if (width == 0) {
            width := this.contentWidth - (this.margin * 2)
        }

        chk := this.guiObj.AddCheckBox("x" . posX . " y" . posY . " w" . width . " h" . height . " v" . ctlName . " checked" . checked, checkboxText)

        if (callback) {
            chk.OnEvent("Click", callback)
        }

        return posY + height + this.margin
    }

    AddTextWithLabel(labelText, content, ctlName, posY, posX := 0, width := 0, labelWidth := 75, height := 20) {
        if (posX == 0) {
            posX := this.margin * 2
        }

        if (width == 0) {
            width := this.contentWidth - (this.margin * 2)
        }

        textX := posX + labelWidth + 5
        textWidth := width - labelWidth - 5

        this.guiObj.AddText("x" . posX . " y" . posY . " w" . labelWidth . " h" . height . " +0x200", labelText . ":")
        this.guiObj.SetFont("Bold")
        this.guiObj.AddText("v" . ctlName . " x" . textX . " y" . posY . " w" . textWidth . " h" . height . " +0x200", content)
        this.guiObj.SetFont()

        return posY + height + this.margin
    }

    OnClose(guiObj) {
        this.guiObj.Submit()
        super.OnEscape(guiObj)
    }

    OnEscape(guiObj) {
        this.guiObj.Cancel()
        super.OnEscape(guiObj)
    }

    OnReloadLauncherFile(btn, info) {
        this.app.ReloadLauncherFile()
    }

    OnOpenLauncherFile(btn, info) {
        this.app.OpenLauncherFile()
    }

    SetText(ctlName, ctlText, fontStyle := "") {
        this.guiObj.SetFont(fontStyle)
        this.guiObj[ctlName].Text := ctlText
        this.guiObj.SetFont()
    }

    OnChangeLauncherFile(btn, info) {
        this.app.ChangeLauncherFile()
        this.SetText("TxtLauncherFile", this.app.AppConfig.LauncherFile, "Bold")
    }

    OnOpenLauncherDir(btn, info) {
        this.app.OpenLauncherDir()
    }

    OnChangeLauncherDir(btn, info) {
        this.app.ChangeLauncherDir()
        this.SetText("TxtLauncherDir", this.app.AppConfig.LauncherDir, "Bold")
    }

    OnIndividualDirs(chk, info) {
        this.guiObj.Submit(false)
        this.app.AppConfig.IndividualDirs := chk.Value
    }

    OnUpdateExistingLaunchers(chk, info) {
        this.guiObj.Submit(false)
        this.app.AppConfig.UpdateExistingLaunchers := chk.Value
    }

    OnCleanLaunchersOnBuild(chk, info) {
        this.guiObj.Submit(false)
        this.app.AppConfig.CleanLaunchersOnBuild := chk.Value
    }

    OnCleanLaunchersOnExit(chk, info) {
        this.guiObj.Submit(false)
        this.app.AppConfig.CleanLaunchersOnExit := chk.Value
    }

    OnOpenAssetsDir(btn, info) {
        this.app.OpenAssetsDir()
    }

    OnChangeAssetsDir(btn, info) {
        this.app.ChangeAssetsDir()
        this.SetText("TxtAssetsDir", this.app.AppConfig.AssetsDir, "Bold")
    }

    OnCopyAssets(chk, info) {
        this.guiObj.Submit(false)
        this.app.AppConfig.CopyAssets := chk.Value
    }

    OnOpenApiEndpoint(btn, info) {
        this.app.OpenApiEndpoint()
    }

    OnChangeApiEndpoint(btn, info) {
        this.app.ChangeApiEndpoint("SettingsWindow")
        this.SetText("TxtApiEndpoint", this.app.AppConfig.ApiEndpoint, "Bold")
    }

    OnFlushCache(btn, info) {
        this.app.FlushCache()
    }

    OnOpenCacheDir(btn, info) {
        this.app.OpenCacheDir()
    }

    OnChangeCacheDir(btn, info) {
        this.app.ChangeCacheDir()
        this.SetText("TxtCacheDir", this.app.AppConfig.CacheDir, "Bold")
    }

    OnFlushCacheOnExit(chk, info) {
        this.guiObj.Submit(false)
        this.app.AppConfig.FlushCacheOnExit := chk.Value
    }
}
