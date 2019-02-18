; This file simply generates an updated Includes.ahk file so it doesn't have to be done manually.

file := "Lib\Includes.ahk"

FileDelete, %file%
FileAppend, % "; Automatically-generated file, do not edit manually.`n", %file%

Loop, Files, Lib\*.ahk, R
{
    if (A_LoopFileFullPath != file) {
        FileAppend, % "#Include " . A_LoopFileFullPath . "`n", %file%
    }
}

FileAppend, % "; End of auto-generated includes.`n", %file%
