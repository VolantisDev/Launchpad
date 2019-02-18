#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Include vendor scripts
#Include Lib\Vendor\JSON.ahk

; Include dependency classes
#Include Lib\Dependencies\Dependency.ahk
#Include Lib\Dependencies\AutoHotKey.ahk
#Include Lib\Dependencies\Bnetlauncher.ahk
#Include Lib\Dependencies\IconsExt.ahk

; Include library classes
#Include Lib\AppConfig.ahk
#Include Lib\ExeBuilder.ahk
#Include Lib\GameAhkFile.ahk
#Include Lib\GameConfig.ahk
#Include Lib\GameIcon.ahk
#Include Lib\GameShortcut.ahk
#Include Lib\LauncherConfig.ahk
#Include Lib\LauncherGen.ahk

SplitPath, A_ScriptName,,,, appName

app := new LauncherGen(appName, A_ScriptDir)
app.UpdateVendorFiles()
app.GenerateLaunchers()
