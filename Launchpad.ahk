;@Ahk2Exe-SetName "Launchpad"
;@Ahk2Exe-SetVersion "{{VERSION}}"
;@Ahk2Exe-SetCompanyName "Volantis Development"
;@Ahk2Exe-SetCopyright "Copyright 2021 Ben McClure"
;@Ahk2Exe-SetDescription "Game Launching Multitool"
#Warn
#Include Lib\Shared\Includes.ahk
#Include Lib\Launchpad\Includes.ahk
; TODO: Allow this path to be changed
#Include "*i %A_AppData%\Launchpad\ModuleIncludes.ahk"

appVersion := "{{VERSION}}"

Launchpad(Map(
    "appName", "Launchpad",
    "developer", "Volantis Development",
    "version", appVersion,
    "trayIcon", "Resources\Graphics\launchpad.ico",
    "console", true
))
