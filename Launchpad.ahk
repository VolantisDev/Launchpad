﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

httpAgent := "AutoHotkeyScript"
httpProxy := 0
httpOption := ""
httpProxyByPass := 0
httpQueryReferer := ""
httpQueryAcceptType := ""
httpQueryDwFlags := ""

Menu, Tray, Icon, Graphics\Launchpad.ico

SplitPath, A_ScriptName,,,, appName

app := new Launchpad(appName, A_ScriptDir)
app.UpdateDependencies()
app.LaunchMainWindow()

~LButton::
{
    MouseGetPos,,,mouseWindow
    WinGet, windowId, Id, Tools - Launchpad
    
    if (windowId != mouseWindow) {
        Gui, ToolsWindow:Cancel
    }
}

#Include Lib\Includes.ahk