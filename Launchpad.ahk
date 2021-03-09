;@Ahk2Exe-SetName "Launchpad"
;@Ahk2Exe-SetVersion "{{VERSION}}"
;@Ahk2Exe-SetCompanyName "Volantis Development"
;@Ahk2Exe-SetCopyright "Copyright 2020 Ben McClure"
;@Ahk2Exe-SetDescription "Game Launching Multitool"
#Warn

A_IconHidden := A_IsCompiled

appVersion := "{{VERSION}}"
#Include Lib\Shared\Includes.ahk
#Include Lib\Launchpad\Includes.ahk

TraySetIcon("Resources\Graphics\Launchpad.ico")
SplitPath(A_ScriptName,,,, appName)

app := Launchpad.new(appName, A_ScriptDir)

~LButton::
{
    global app

    if (IsSet(app) && app.Windows.WindowIsOpen("ToolsWindow")) {
        MouseGetPos(,,mouseWindow)
        toolsObj := app.Windows.GetGuiObj("ToolsWindow")

        if (toolsObj.Hwnd != mouseWindow) {
            app.Windows.CloseToolsWindow()
        }
    }
    
}
