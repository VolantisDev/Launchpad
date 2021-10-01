;@Ahk2Exe-SetName "{{launcherName}}"
;@Ahk2Exe-SetVersion "{{appVersion}}"
;@Ahk2Exe-SetCompanyName "Volantis Development"
;@Ahk2Exe-SetCopyright 'Copyright 2021 Ben McClure'
;@Ahk2Exe-SetDescription 'Launchpad Game Launcher'
#Warn
#Include {{appDir}}\Lib\Shared\Includes.ahk
#Include {{appDir}}\Lib\LaunchpadLauncher\Includes.ahk

appVersion := "{{appVersion}}"
gameConfigObj := {%gameConfig%}
launchpadLauncherConfigObj := {%launchpadLauncherConfig%}
launcherConfigObj := {%launcherConfig%}

LaunchpadLauncher(Map(
    "appName", "{{launcherName}}",
    "developer", "Volantis Development",
    "version", "{{appVersion}}",
    "console", true,
    "launcherKey", "{{launcherKey}}",
    "themesDir", "{{themesDir}}",
    "resourcesDir", "{{resourcesDir}}",
    "themeName", "{{themeName}}",
    "launchpadLauncherConfig", launchpadLauncherConfigObj,
    "launcherConfig", launcherConfigObj,
    "gameConfig", gameConfigObj,
    "platforms", {%platforms%},
    "parameters", Map(
        "launcher_key", "{{launcherKey}}",
        "launchpad_launcher_config", launchpadLauncherConfigObj,
        "launcher_config", launcherConfigObj,
        "game_config", gameConfigObj
    ),
    "coreServices", Map(
        "Config", Map(
            "class", "LaunchpadLauncherConfig",
            "arguments", [
                AppRef(), 
                ParameterRef("launchpad_launcher_config"), 
                ParameterRef("launcher_config"), 
                ParameterRef("game_config"), 
                ParameterRef("config_path")
            ]
        ),
        "State", Map(
            "class", "LaunchpadLauncherState",
            "arguments", [
                AppRef(), 
                ParameterRef("state_path")
            ]
        )
    )
))
