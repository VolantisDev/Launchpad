if "%AHK_2%"=="" (
    start "" /D "%CD%" "Launchpad.ahk"
) else (
    "%AHK_2%" "%CD%\Launchpad.ahk"
)
