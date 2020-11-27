#Warn
#Include Lib\Shared\Includes.ahk
#Include Lib\Launchpad\Includes.ahk

TraySetIcon("Graphics\Launchpad.ico")

SplitPath(A_ScriptName,,,, appName)

app := Launchpad.new(appName, A_ScriptDir)
app.Dependencies.UpdateDependencies()
app.Windows.OpenMainWindow()

; OnError("HandleError")

; HandleError(thrown, mode) {
;     MsgBox("An unhandled error has occurred. Exiting Launchpad.")
;     ExitApp
; }

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
