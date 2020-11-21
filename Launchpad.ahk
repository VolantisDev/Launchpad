#Warn
#Include LauncherLib\Includes.ahk
#Include Lib\Includes.ahk

TraySetIcon("Graphics\Launchpad.ico")

SplitPath(A_ScriptName,,,, appName)

app := Launchpad.new(appName, A_ScriptDir)
app.UpdateDependencies()
app.GuiManager.OpenMainWindow()

~LButton::
{
    global app

    if (IsSet(app) and app.GuiManager.WindowIsOpen("ToolsWindow")) {
        MouseGetPos(,,mouseWindow)
        toolsObj := app.GuiManager.GetGuiObj("ToolsWindow")

        if (toolsObj.Hwnd != mouseWindow) {
            app.GuiManager.CloseToolsWindow()
        }
    }
    
}
