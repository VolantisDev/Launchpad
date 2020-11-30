#Warn

A_IconHidden := A_IsCompiled

#Include Lib\Shared\Includes.ahk
#Include Lib\Launchpad\Includes.ahk

TraySetIcon("Graphics\Launchpad.ico")

SplitPath(A_ScriptName,,,, appName)

try {
    app := Launchpad.new(appName, A_ScriptDir)
    app.Installers.InstallRequirements()
    app.Launchers.LoadLaunchers()
    app.Windows.OpenMainWindow()
} catch e {
    extra := (e.HasProp("Extra") and e.Extra != "") ? "`n`nAdditional info:`n" . e.Extra : ""
    MsgBox "An unhandled exception has occurred in " . e.What . ".`n`n" . e.Message . extra . "`n`nLaunchpad will now exit."
    ExitApp
}


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
