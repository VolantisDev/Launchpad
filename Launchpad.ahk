;@Ahk2Exe-SetName "Launchpad"
;@Ahk2Exe-SetVersion "{{VERSION}}"
;@Ahk2Exe-SetCompanyName "Volantis Development"
;@Ahk2Exe-SetCopyright "Copyright 2021 Ben McClure"
;@Ahk2Exe-SetDescription "Game Launching Multitool"
#Warn
#Include Lib\Shared\Includes.ahk
#Include Lib\Launchpad\Includes.ahk

appVersion := "{{VERSION}}"

Launchpad(Map(
    "appName", "Launchpad",
    "developer", "Volantis Development",
    "version", appVersion,
    "trayIcon", "Resources\Graphics\Launchpad.ico",
    "console", true,
    "coreServices", Map(
        "Config", Map(
            "class", "LaunchpadConfig",
            "arguments", [AppRef(), ParameterRef("config_path")]
        ),
        "State", Map(
            "class", "LaunchpadAppState",
            "arguments", [AppRef(), ParameterRef("state_path")]
        )
    )
))
