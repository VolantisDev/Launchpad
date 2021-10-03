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
    "platforms", {%platforms%}
))