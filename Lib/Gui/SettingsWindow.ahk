class SettingsWindow extends Gui {
    windowOptions := "-MaximizeBox -SysMenu"
    windowSize := "w370"
    label := "SettingsWindow"
    contentWidth := 350

    __New(app, owner := 0) {
        base.__New(app, "Settings", owner)
    }

    Controls(posY) {
        global ChkCleanLaunchersOnBuild, ChkCleanLaunchersOnExit, ChkFlushCacheOnExit, ChkUpdateExistingLaunchers, ChkIndividualDirs, ChkCopyAssets, TxtLauncherFile, TxtLauncherDir, TxtAssetsDir, TxtApiEndpoint, TxtCacheDir

        posY := base.Controls(posY)
        
        updateExistingLaunchersChecked := this.app.AppConfig.UpdateExistingLaunchers
        individualDirsChecked := this.app.AppConfig.IndividualDirs
        copyAssetsChecked := this.app.AppConfig.CopyAssets
        cleanLaunchersOnBuildChecked := this.app.AppConfig.CleanLaunchersOnBuild
        cleanLaunchersOnExitChecked := this.app.AppConfig.CleanLaunchersOnExit
        flushCacheOnExitChecked := this.app.AppConfig.FlushCacheOnExit

        launcherFile := this.app.AppConfig.LauncherFile ? this.app.AppConfig.LauncherFile : "Not selected"
        launcherDir := this.app.AppConfig.LauncherDir ? this.app.AppConfig.LauncherDir : "Not selected"
        assetsDir := this.app.AppConfig.AssetsDir ? this.app.AppConfig.AssetsDir : "Not selected"
        apiEndpointVal := this.app.AppConfig.ApiEndpoint ? this.app.AppConfig.ApiEndpoint : "Not selected"
        cacheDir := this.app.AppConfig.CacheDir ? this.app.AppConfig.CacheDir : "Not selected"

        margin := this.margin
        width := this.contentWidth
        groupX := margin * 2
        groupW := width - (margin * 2)
        labelW := 75
        textX := groupX + labelW + 5
        textW := groupW - labelW - 5
        smallButtonW := 80
        buttonRightFirstX := groupX + groupW - (smallbuttonW * 2) - margin
        buttonRightSecondX := buttonRightFirstX + smallButtonW + margin

        Gui Add, GroupBox, x%margin% y%posY% w%width% h255, Launchers
        posY += 5 + margin
        Gui Add, Text, x%groupX% y%posY% w%labelW% h20 +0x200, Launcher File:
        Gui, Font, Bold
        Gui Add, Text, vTxtLauncherFile x%textX% y%posY% w%textW% h20 +0x200, %launcherFile%
        Gui, Font, Norm
        posY += 20 + margin
        buttonX := groupX
        Gui Add, Button, gSettingsWindowReloadLauncherFile x%buttonX% y%posY% w%smallButtonW% h20, &Reload
        buttonX += smallButtonW + margin
        Gui Add, Button, gSettingsWindowOpenLauncherFile x%buttonRightFirstX% y%posY% w%smallButtonW% h20, Open
        Gui Add, Button, gSettingsWindowChangeLauncherFile x%buttonRightSecondX% y%posY% w%smallButtonW% h20, Change
        posY += 20 + margin
        Gui Add, Text, x%groupX% y%posY% w%labelW% h20 +0x200, Launcher Dir:
        Gui, Font, Bold
        Gui Add, Text, vTxtLauncherDir x%textX% y%posY% w%textW% h20 +0x200, %launcherDir%
        Gui, Font, Norm
        posY += 20 + margin
        Gui Add, Button, gSettingsWindowOpenLauncherDir x%buttonRightFirstX% y%posY% w%smallButtonW% h20, Open
        Gui Add, Button, gSettingsWindowChangeLauncherDir x%buttonRightSecondX% y%posY% w%smallButtonW% h20, Change
        posY += 20 + margin
        Gui Add, CheckBox, x%groupX% y%posY% w%groupW% h20 gSettingsWindowIndividualDirs vChkIndividualDirs checked%individualDirsChecked%, Create individual launcher directories
        posY += 20 + margin
        Gui Add, CheckBox, x%groupX% y%posY% w%groupW% h20 gSettingsWindowUpdateExistingLaunchers vChkUpdateExistingLaunchers checked%updateExistingLaunchersChecked%, Update existing launchers on build
        posY += 20 + margin
        Gui Add, CheckBox, x%groupX% y%posY% w%groupW% h20 gSettingsWindowCleanLaunchersOnBuild vChkCleanLaunchersOnBuild checked%cleanLaunchersOnBuildChecked%, Clean launchers on build
        posY += 20 + margin
        Gui Add, CheckBox, x%groupX% y%posY% w%groupW% h20 gSettingsWindowCleanLaunchersOnExit vChkCleanLaunchersOnExit checked%cleanLaunchersOnExitChecked%, Clean launchers on exit
        posY += 20 + margin + margin

        Gui Add, GroupBox, x%margin% y%posY% w%width% h105, Assets
        posY += 5 + margin
        Gui Add, Text, x%groupX% y%posY% w%labelW% h20 +0x200, Assets Dir:
        Gui, Font, Bold
        Gui Add, Text, vTxtAssetsDir x%textX% y%posY% w%textW% h20 +0x200, %assetsDir%
        Gui, Font, Norm
        posY += 20 + margin
        Gui Add, Button, gSettingsWindowOpenAssetsDir x%buttonRightFirstX% y%posY% w%smallButtonW% h20, Open
        Gui Add, Button, gSettingsWindowChangeAssetsDir x%buttonRightSecondX% y%posY% w%smallButtonW% h20, Change
        posY += 20 + margin
        Gui Add, CheckBox, x%groupX% y%posY% w%groupW% h20 gSettingsWindowCopyAssets vChkCopyAssets checked%copyAssetsChecked%, Copy assets to launcher directory
        posY += 20 + margin + margin

        Gui Add, GroupBox, x%margin% y%posY% w%width% h80, API
        posY += 5 + margin
        Gui Add, Text, x%groupX% y%posY% w%labelW% h20 +0x200, Endpoint URL:
        Gui, Font, Bold
        Gui Add, Text, vTxtApiEndpoint x%textX% y%posY% w%textW% h20 +0x200, %apiEndpointVal%
        Gui, Font, Norm
        posY += 20 + margin
        Gui Add, Button, gSettingsWindowOpenApiEndpoint x%buttonRightFirstX% y%posY% w%smallButtonW% h20, Open
        Gui Add, Button, gSettingsWindowChangeApiEndpoint x%buttonRightSecondX% y%posY% w%smallButtonW% h20, Change
        posY += 20 + margin + margin

        Gui, Add, GroupBox, x%margin% y%posY% w%width% h105, Cache
        posY += 5 + margin
        Gui Add, Text, x%groupX% y%posY% w%labelW% h20 +0x200, Cache Dir:
        Gui, Font, Bold
        Gui Add, Text, vTxtCacheDir x%textX% y%posY% w%textW% h20 +0x200, %cacheDir%
        Gui, Font, Norm
        posY += 20 + margin
        Gui Add, Button, gSettingsWindowFlushCache x%groupX% y%posY% w%smallButtonW% h20, &Flush
        Gui Add, Button, gSettingsWindowOpenCacheDir x%buttonRightFirstX% y%posY% w%smallButtonW% h20, Open
        Gui Add, Button, gSettingsWindowChangeCacheDir x%buttonRightSecondX% y%posY% w%smallButtonW% h20, Change
        posY += 20 + margin
        Gui Add, CheckBox, x%groupX% y%posY% w%groupW% h20 gSettingsWindowFlushCacheOnExit vChkFlushCacheOnExit checked%flushCacheOnExitChecked%, Flush cache on exit
        posY += 20 + margin + margin

        Gui Add, Button, gSettingsWindowClose x%margin% y%posY% w%width% h30, &Save && Close
        posY += 30 + margin

        return posY
    }
}

SettingsWindowEscape:
{
    Gui, SettingsWindow:Cancel
    Return
}

SettingsWindowClose:
{
    Gui, SettingsWindow:Submit
    Return
}

SettingsWindowReloadLauncherFile:
{
    app.ReloadLauncherFile()
    Return
}

SettingsWindowOpenLauncherFile:
{
    app.OpenLauncherFile()
    Return
}

SettingsWindowChangeLauncherFile:
{
    app.ChangeLauncherFile()
    Gui, SettingsWindow:Font, Bold
    GuiControl, SettingsWindow:Text, TxtLauncherFile, % app.AppConfig.LauncherFile
    Gui, SettingsWindow:Font, Norm
    Return
}

SettingsWindowOpenLauncherDir:
{
    app.OpenLauncherDir()
    Return
}

SettingsWindowChangeLauncherDir:
{
    app.ChangeLauncherDir()
    Gui, SettingsWindow:Font, Bold
    GuiControl, SettingsWindow:Text, TxtLauncherDir, % app.AppConfig.LauncherDir
    Gui, SettingsWindow:Font, Norm
    Return
}

SettingsWindowIndividualDirs:
{
    Gui, SettingsWindow:Submit, NoHide
    app.AppConfig.IndividualDirs := ChkIndividualDirs
    Return
}

SettingsWindowUpdateExistingLaunchers:
{
    Gui, SettingsWindow:Submit, NoHide
    app.AppConfig.UpdateExistingLaunchers := ChkUpdateExistingLaunchers
    Return
}

SettingsWindowCleanLaunchersOnBuild:
{
    Gui, SettingsWindow:Submit, NoHide
    app.AppConfig.CleanLaunchersOnBuild := ChkCleanLaunchersOnBuild
    Return
}

SettingsWindowCleanLaunchersOnExit:
{
    Gui, SettingsWindow:Submit, NoHide
    app.AppConfig.CleanLaunchersOnExit := ChkCleanLaunchersOnExit
    Return
}

SettingsWindowOpenAssetsDir:
{
    app.OpenAssetsDir()
    Return
}

SettingsWindowChangeAssetsDir:
{
    app.ChangeAssetsDir()
    Gui, SettingsWindow:Font, Bold
    GuiControl, SettingsWindow:Text, TxtAssetsDir, % app.AppConfig.AssetsDir
    Gui, SettingsWindow:Font, Norm
    Return
}

SettingsWindowCopyAssets:
{
    Gui, SettingsWindow:Submit, NoHide
    app.AppConfig.CopyAssets := ChkCopyAssets
    Return
}

SettingsWindowOpenApiEndpoint:
{
    Run, % app.AppConfig.ApiEndpoint
    Return
}

SettingsWindowChangeApiEndpoint:
{
    app.ChangeApiEndpoint()
    Gui, SettingsWindow:Font, Bold
    GuiControl, SettingsWindow:Text, TxtApiEndpoint, % app.AppConfig.ApiEndpoint
    Gui, SettingsWindow:Font, Norm
    Return
}

SettingsWindowFlushCache:
{
    app.FlushCache()
    Return
}

SettingsWindowOpenCacheDir:
{
    Run, % app.AppConfig.CacheDir
    Return
}

SettingsWindowChangeCacheDir:
{
    app.ChangeCacheDir()
    Gui, SettingsWindow:Font, Bold
    GuiControl, SettingsWindow:Text, TxtCacheDir, % app.AppConfig.CacheDir
    Gui, SettingsWindow:Font, Norm
    Return
}

SettingsWindowFlushCacheOnExit:
{
    Gui, SettingsWindow:Submit, NoHide
    app.AppConfig.FlushCacheOnExit := ChkFlushCacheOnExit
    Return
}
