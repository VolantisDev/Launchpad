if "%AHK_2%"=="" (
    start "" /D "%CD%" "UpdateIncludes.ahk"
) else (
    "%AHK_2%" "%CD%\UpdateIncludes.ahk"
)
