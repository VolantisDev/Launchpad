if "%AHK_2%"=="" (
    start "" /D "%CD%" "LaunchpadUpdater.ahk"
) else (
    "%AHK_2%" "%CD%\LaunchpadUpdater.ahk"
)
