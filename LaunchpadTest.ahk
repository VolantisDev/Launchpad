#Warn

#Include Lib\Shared\Includes.ahk
#Include Lib\Shared\Includes.test.ahk
#Include Lib\TestLib\Includes.ahk
#Include Lib\TestLib\Includes.test.ahk
#Include Lib\Launchpad\Includes.ahk
#Include Lib\Launchpad\Includes.test.ahk
#Include Lib\LaunchpadBuilder\Includes.ahk
#Include Lib\LaunchpadBuilder\Includes.test.ahk
#Include Lib\LaunchpadLauncher\Includes.ahk
#Include Lib\LaunchpadLauncher\Includes.test.ahk

appVersion := "1.0.0"

TraySetIcon("Resources\Graphics\Launchpad.ico")

HtmlResultViewer("Launchpad Test")
    .ViewResults(SimpleTestRunner(FilesystemTestLoader().GetTests()).RunTests())
