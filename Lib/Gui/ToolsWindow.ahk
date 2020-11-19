class ToolsWindow extends Gui {
    windowOptions := "+AlwaysOnTop -Caption Border"
    windowSize := "w220"
    label := "ToolsWindow"
    contentWidth := 200
    positionAtMouseCursor := true

    __New(app, owner := 0) {
        base.__New(app, "Tools", owner)
    }

    Controls(posY) {
        posY := base.Controls(posY)

        margin := this.margin
        controlWidth := this.contentWidth

        Gui Add, Button, gToolsWindowReloadLauncherFile x%margin% y%posY% w%controlWidth% h40, &Reload Launcher File
        posY += 40 + margin
        Gui Add, Button, gToolsWindowCleanLaunchers x%margin% y%posY% w%controlWidth% h40, &Clean Launchers
        posY += 40 + margin
        Gui Add, Button, gToolsWindowUpdateDependencies x%margin% y%posY% w%controlWidth% h40, &Update Dependencies
        posY += 40 + margin
        Gui Add, Button, gToolsWindowFlushCache x%margin% y%posY% w%controlWidth% h40, &Flush Cache
        posY += 40 + margin

        return posY
    }
}

ToolsWindowEscape:
ToolsWindowClose:
{
    Gui, ToolsWindow:Cancel
    Return
}

 ToolsWindowReloadLauncherFile:
{
    Gui, ToolsWindow:Cancel
    app.ReloadLauncherFile()
    Return
}
        
ToolsWindowCleanLaunchers:
{
    Gui, ToolsWindow:Cancel
    app.Cleanup()
    Return
}

ToolsWindowFlushCache:
{
    Gui, ToolsWindow:Cancel
    app.FlushCache()
    Return
}

ToolsWindowUpdateDependencies:
{
    Gui, ToolsWindow:Cancel
    app.UpdateDependencies(true)
    Return
}
