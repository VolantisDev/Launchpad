class MainWindow {
    Show() {
        ;global app
        global app, ChkIndividualDirs, ChkCopyAssets, TxtLauncherFile, TxtLauncherDir, ChkCreateIndividualDirs, TxtAssetsDir, ChkCopyToLauncher

        individualDirsChecked := app.AppConfig.IndividualDirs
        copyAssetsChecked := app.AppConfig.CopyAssets

        localApp := this.app

        Gui, LauncherGen:New, -MaximizeBox -SysMenu, LauncherGen

        Gui Add, GroupBox, x10 y10 w330 h105, Launchers

        Gui Add, Button, gBuildAll x20 y30 w150 h40, Build &All
        Gui Add, Button, gBuildMissing x180 y30 w150 h40, Build &Missing
        Gui Add, Button, gManageLaunchers x20 y80 w150 h25, Manage &Launchers
        Gui Add, Button, gRemoveBuilt x180 y80 w150 h25, &Clean Launchers

        Gui Add, GroupBox, x10 y120 w330 h70, Launcher File
        Gui Add, Text, x20 y135 w25 h20 +0x200, Path:
        Gui Add, Text, vTxtLauncherFile x50 y135 w280 h20 +0x200, % app.AppConfig.LauncherFile
        Gui Add, Button, gReloadLauncherFile x20 y160 w80 h20, &Reload
        Gui Add, Button, gOpenLauncherFile x165 y160 w80 h20, Open
        Gui Add, Button, gChangeLauncherFile x250 y160 w80 h20, Change

        Gui Add, GroupBox, x10 y195 w330 h70, Launcher Dir
        Gui Add, Text, x20 y210 w25 h20 +0x200, Path:
        Gui Add, Text, vTxtLauncherDir x50 y210 w280 h20 +0x200, % app.AppConfig.LauncherDir
        Gui Add, CheckBox, gIndividualDirs vChkIndividualDirs checked%individualDirsChecked% x20 y235 w120 h20, Individual dirs
        Gui Add, Button, gOpenLauncherDir x165 y235 w80 h20, Open
        Gui Add, Button, gChangeLauncherDir x250 y235 w80 h20, Change

        Gui Add, GroupBox, x10 y270 w330 h70, Assets Dir
        Gui Add, Text, x20 y285 w25 h20 +0x200, Path:
        Gui Add, Text, vTxtAssetsDir x50 y285 w280 h20 +0x200, % app.AppConfig.AssetsDir
        Gui Add, CheckBox, gCopyAssets vChkCopyAssets checked%copyAssetsChecked% x20 y310 w120 h20, Copy to launcher
        Gui Add, Button, gOpenAssetsDir x165 y310 w80 h20, Open
        Gui Add, Button, gChangeAssetsDir x250 y310 w80 h20, Change

        Gui Add, GroupBox, x10 y345 w330 h55, Tools
        Gui Add, Button, gUpdateDependencies x20 y360 w150 h30, &Update Dependencies
        Gui Add, Button, gFlushCache x180 y360 w150 h30, &Flush Cache

        Gui Add, Button, gCleanAndExit x10 y405 w160 h30, Cleanup && E&xit
        Gui Add, Button, gGuiClose x180 y405 w160 h30, &Exit

        Gui Show, w350 h445
        Return

        GuiEscape:
        GuiClose:
            ExitApp

        BuildAll:
        {
            app.BuildLaunchers(true)
            Return
        }
            

        BuildMissing:
        {
            app.BuildLaunchers(false)
            Return
        }

        ManageLaunchers:
        {
            app.LaunchManageWindow()
            Return
        }

        RemoveBuilt:
        {
            app.Cleanup()
            Return
        }

        ReloadLauncherFile:
        {
            app.ReloadLauncherFile()
            Return
        }

        OpenLauncherFile:
        {
            app.OpenLauncherFile()
            Return
        }

        ChangeLauncherFile:
        {
            app.ChangeLauncherFile()
            GuiControl, LauncherGen:Text, TxtLauncherFile, % app.AppConfig.LauncherFile
            Return
        }

        IndividualDirs:
        {
            Gui, LauncherGen:Submit, NoHide
            app.AppConfig.IndividualDirs := ChkIndividualDirs
            Return
        }

        OpenLauncherDir:
        {
            app.OpenLauncherDir()
            Return
        }

        ChangeLauncherDir:
        {
            app.ChangeLauncherDir()
            GuiControl, LauncherGen:Text, TxtLauncherDir, % app.AppConfig.LauncherDir
            Return
        }

        CopyAssets:
        {
            Gui, LauncherGen:Submit, NoHide
            app.AppConfig.CopyAssets := ChkCopyAssets
            Return
        }

        OpenAssetsDir:
        {
            app.OpenAssetsDir()
            Return
        }

        ChangeAssetsDir:
        {
            app.ChangeAssetsDir()
            GuiControl, LauncherGen:Text, TxtAssetsDir, % app.AppConfig.AssetsDir
            Return
        }

        UpdateDependencies:
        {
            app.UpdateDependencies(true)
            Return
        }

        FlushCache:
        {
            app.FlushCache()
            Return
        }

        CleanAndExit:
        {
            app.FlushCache()
            app.Cleanup()
            ExitApp
        }
    }
}
