; This file simply generates an updated Includes.ahk file so it doesn't have to be done manually.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

appDir := RegExReplace(A_ScriptDir, "\\[^\\]+$")

GenerateIncludeFile(file, glob) {
    FileDelete, %file%
    FileAppend, % "; Automatically-generated file, do not edit manually.`n", %file%

    Loop, Files, %glob%, R
    {
        if (A_LoopFileFullPath != file) {
            FileAppend, % "#Include " . A_LoopFileFullPath . "`n", %file%
        }
    }

    FileAppend, % "; End of auto-generated includes.`n", %file%
}

GenerateIncludeFile(appDir . "\Lib\Includes.ahk", appDir . "\Lib\*.ahk")
GenerateIncludeFile(appDir . "\LauncherLib\Includes.ahk", appDir . "\LauncherLib\*.ahk")
