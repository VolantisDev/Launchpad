; This file simply generates an updated Includes.ahk file so it doesn't have to be done manually.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir RegExReplace(A_ScriptDir,"[^\\]+\\?$")  ; Ensures a consistent starting directory.

file := "Lib\Includes.ahk"

FileDelete, %file%
FileAppend, % "; Automatically-generated file, do not edit manually.`n", %file%

Loop, Files, %A_WorkingDir%\Lib\*.ahk, R
{
    if (A_LoopFileFullPath != file) {
        FileAppend, % "#Include " . A_LoopFileFullPath . "`n", %file%
    }
}

FileAppend, % "; End of auto-generated includes.`n", %file%
