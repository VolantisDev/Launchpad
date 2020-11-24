#Warn
#Include Lib\Includes.ahk

TraySetIcon("Graphics\Launchpad.ico")

SplitPath(A_ScriptName,,,, appName)

app := Launchpad.new(appName, A_ScriptDir)
app.Dependencies.UpdateDependencies()
app.Windows.OpenMainWindow()

~LButton::
{
    global app

    if (IsSet(app) and app.Windows.WindowIsOpen("ToolsWindow")) {
        MouseGetPos(,,mouseWindow)
        toolsObj := app.Windows.GetGuiObj("ToolsWindow")

        if (toolsObj.Hwnd != mouseWindow) {
            app.Windows.CloseToolsWindow()
        }
    }
    
}
