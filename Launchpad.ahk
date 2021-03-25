;@Ahk2Exe-SetName "Launchpad"
;@Ahk2Exe-SetVersion "{{VERSION}}"
;@Ahk2Exe-SetCompanyName "Volantis Development"
;@Ahk2Exe-SetCopyright "Copyright 2020 Ben McClure"
;@Ahk2Exe-SetDescription "Game Launching Multitool"
#Warn

DllCall("AllocConsole")
WinHide("ahk_id " . DllCall("GetConsoleWindow", "ptr"))

A_IconHidden := A_IsCompiled

appVersion := "{{VERSION}}"
#Include Lib\Shared\Includes.ahk
#Include Lib\Launchpad\Includes.ahk

TraySetIcon("Resources\Graphics\Launchpad.ico")
SplitPath(A_ScriptName,,,, appName)

app := Launchpad.new(appName, A_ScriptDir)
