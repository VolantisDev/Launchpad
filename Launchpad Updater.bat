if "%AHK_2%"=="" (
    start "" /D "%CD%" "Launchpad Updater.ahk"
) else (
    "%AHK_2%" "%CD%\Launchpad Updater.ahk"
)
