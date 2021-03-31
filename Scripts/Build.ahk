#Warn

DllCall("AllocConsole")
WinHide("ahk_id " . DllCall("GetConsoleWindow", "ptr"))

appDir := RegExReplace(A_ScriptDir, "\\[^\\]+$")
appVersion := "{{VERSION}}"
#Include ..\Lib\Shared\Includes.ahk
#Include ..\Lib\Launchpad\Includes.ahk
#Include ..\Lib\LaunchpadBuilder\Includes.ahk

TraySetIcon(appDir . "\Resources\Graphics\Launchpad.ico")

appInfo := Map()
appInfo["appDir"] := appDir
appInfo["appName"] := "Launchpad"
appInfo["developer"] := "Volantis Development"
appInfo["version"] := appVersion
appInfo["configClass"] := "LaunchpadBuilderConfig"
appInfo["configFile"] := appDir . "\" . appInfo["appName"] . "build.ini"
appInfo["BuildClass"] := "Launchpad"
LaunchpadBuilder.new(appInfo)
