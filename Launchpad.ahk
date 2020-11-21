#Warn
#Include LauncherLib\Includes.ahk
#Include Lib\Includes.ahk

TraySetIcon("Graphics\Launchpad.ico")

SplitPath(A_ScriptName,,,, appName)

app := Launchpad.new(appName, A_ScriptDir)
app.UpdateDependencies()
app.Guis.OpenMainWindow()

~LButton::
{
    global app
    MouseGetPos(,,mouseWindow)
    windowId := WinGetID("Tools - Launchpad")
    
    if (windowId != mouseWindow) {
        app.Guis.CloseToolsWindow()
    }
}
