#Warn

A_IconHidden := A_IsCompiled

#Include Lib\Shared\Includes.ahk
#Include Lib\Launchpad\Includes.ahk

if (FileExist("Graphics\Launchpad.ico")) {
    TraySetIcon("Graphics\Launchpad.ico")
}


SplitPath(A_ScriptName,,,, appName)

try {
    app := Launchpad.new(appName, A_ScriptDir)
    app.Installers.InstallRequirements()
    app.Launchers.LoadLaunchers()
    app.Windows.OpenMainWindow()
} catch e {
    extra := (e.HasProp("Extra") and e.Extra != "") ? "`n`nAdditional info:`n" . e.Extra : ""
    occurredIn := e.What ? " in " . e.What : ""
    MsgBox "An unhandled exception has occurred" . occurredIn . ".`n`n" . e.Message . extra . "`n`nDebugging Information:`nFile: " . e.File . "`nLine: " . e.Line . "`n`nLaunchpad will now exit."
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
