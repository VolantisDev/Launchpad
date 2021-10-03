#Warn
#Include ..\Lib\Shared\Includes.ahk
#Include ..\Lib\Launchpad\Includes.ahk
#Include ..\Lib\LaunchpadBuilder\Includes.ahk

appDir := RegExReplace(A_ScriptDir, "\\[^\\]+$")
appVersion := "{{VERSION}}"

LaunchpadBuilder(Map(
    "appDir", appDir,
    "appName", "Launchpad",
    "developer", "Volantis Development",
    "version", appVersion,
    "trayIcon", appDir . "\Resources\Graphics\Launchpad.ico",
    "console", true,
))
