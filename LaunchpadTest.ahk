#Warn

DllCall("AllocConsole")
WinHide("ahk_id " . DllCall("GetConsoleWindow", "ptr"))

appVersion := "1.0.0"
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

TraySetIcon("Resources\Graphics\Launchpad.ico")

RunLaunchpadTests() {
    testLoader := FilesystemTestLoader()
    tests := testLoader.GetTests()

    testRunner := SimpleTestRunner(tests)
    results := testRunner.RunTests()

    resultTemplate := A_ScriptDir . "\Resources\Tests\test-results.html"
    resultViewer := HtmlResultViewer(resultTemplate)
    resultViewer.ViewResults(results)
}

RunLaunchpadTests()