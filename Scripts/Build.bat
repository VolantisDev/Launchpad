if "%AHK_2%"=="" (
    start "" /D "%CD%" "Build.ahk"
) else (
    "%AHK_2%" "%CD%\Build.ahk"
)
