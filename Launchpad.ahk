;@Ahk2Exe-SetName "Launchpad"
;@Ahk2Exe-SetVersion "{{VERSION}}"
;@Ahk2Exe-SetCompanyName "Volantis Development"
;@Ahk2Exe-SetCopyright "Copyright 2021 Ben McClure"
;@Ahk2Exe-SetDescription "Game Launching Multitool"
#Warn

DllCall("AllocConsole")
WinHide("ahk_id " . DllCall("GetConsoleWindow", "ptr"))

A_IconHidden := A_IsCompiled

appVersion := "{{VERSION}}"
#Include Lib\Shared\Includes.ahk
#Include Lib\Launchpad\Includes.ahk

TraySetIcon("Resources\Graphics\Launchpad.ico")

appInfo := Map()
appInfo["appName"] := "Launchpad"
appInfo["developer"] := "Volantis Development"
appInfo["version"] := appVersion
appInfo["configClass"] := "LaunchpadConfig"
appInfo["stateClass"] := "LaunchpadAppState"

Launchpad.new(appInfo)
