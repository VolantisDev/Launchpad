class MainWindow extends Gui {
    windowSize := "w535"
    label := "MainWindow"
    contentWidth := 515

    GetTitle() {
        return this.title
    }

    Controls(posY) {
        guiLabel := this.label
        width := this.contentWidth
        margin := this.margin

        posY := base.Controls(posY)

        logo := this.app.AppConfig.AppDir . "\Graphics\Logo.png"

        Gui %guiLabel%:Add, Picture, gMainWindowLogo x%margin% y%posY% w%width% h-1 +BackgroundTrans, %logo%
        
        posY += 205 + margin

        areaW := 430
        areaX := margin + ((width - areaW) / 2)

        buttonWidth := this.ButtonWidth(2, areaW)
        buttonHeight := 80
        posX := areaX
        Gui Add, Button, gMainWindowManageLaunchers x%posX% y%posY% w%buttonWidth% h%buttonHeight% Disabled, &Manage Launchers
        posX += buttonWidth + margin
        Gui Add, Button, gMainWindowBuild x%posX% y%posY% w%buttonWidth% h%buttonHeight%, &Build Launchers
        posY += buttonHeight + margin

        buttonWidth := this.ButtonWidth(3, areaW)
        buttonHeight := 30
        posX := areaX
        Gui Add, Button, gMainWindowTools x%posX% y%posY% w%buttonWidth% h%buttonHeight%, &Tools
        posX += buttonWidth + margin
        Gui Add, Button, gMainWindowSettings x%posX% y%posY% w%buttonWidth% h%buttonHeight%, &Settings
        posX += buttonWidth + margin
        Gui Add, Button, gMainWindowClose x%posX% y%posY% w%buttonWidth% h%buttonHeight%, &Exit
        posY += buttonHeight + (margin * 3)

        bottomMargin := margin * 3
        Gui, Margin, %margin%, %bottomMargin%

        return posY
    }
}

MainWindowEscape:
MainWindowClose:
{
    app.ExitApp()
    Return
}

MainWindowLogo:
{
    Run, https://github.com/bmcclure/Launchpad
    Return
}

MainWindowBuild:
{
    app.BuildLaunchers(app.AppConfig.UpdateExistingLaunchers)
    Return
}

MainWindowManageLaunchers:
{
    app.LaunchManageWindow()
    Return
}

MainWindowTools:
{
    app.LaunchToolsWindow()
    Return
}

MainWindowSettings:
{
    app.LaunchSettingsWindow()
    Return
}
