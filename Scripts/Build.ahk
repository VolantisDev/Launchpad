#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
appDir := RegExReplace(A_ScriptDir, "\\[^\\]+$")

buildDir := appDir . "\Build"
ahkScript := appDir . "\Launchpad.ahk"
exeFile := buildDir . "\Launchpad.exe"
iconFile := appDir . "\Graphics\Launchpad.ico"
zipPath := appDir . "\Launchpad.zip"
ahk2Exe := appDir . "\Vendor\AutoHotKey\Compiler\Ahk2Exe.exe"

if (!FileExist(ahk2Exe)) {
    FileSelectFile, ahk2Exe, 3,,Please select your Ahk2Exe.exe file, EXE Files (*.exe)
    if (ahk2Exe == "") {
        MsgBox, Could not find Ahk2Exe.exe
        ExitApp, -1
    }
}

FileRemoveDir, %buildDir%, 1
FileCreateDir, %buildDir%
RunWait, %ahk2Exe% /in "%ahkScript%" /out "%exeFile%" /icon "%iconFile%"
FileCopy, %appDir%\Launchers.json.sample, %buildDir%\Launchers.json.sample
FileCopy, %appDir%\LICENSE.txt, %buildDir%\LICENSE.txt
FileCopy, %appDir%\README.md, %buildDir%\README.md
FileCopyDir, %appDir%\LauncherLib, %buildDir%\LauncherLib

MsgBox, You may now modify the Build directory if you would like before creating the zip file. When finished, click OK to create zip archive.

Zip(buildDir, zipPath)
FileRemoveDir, %buildDir%, true

MsgBox, Finished creating %zipPath%

Zip(zipDir, zipFile) {
    FileDelete, %zipFile%
    CreateZipFile(zipFile)

    psh := ComObjCreate("Shell.Application")
    pshZip := psh.Namespace(zipFile)

    Loop, Files, %zipDir%\*, DF
    {
        Sleep, 1000
        pshZip.CopyHere(A_LoopFileFullPath, 4|16)
    }

    Sleep, 2000
}

CreateZipFile(zipFile)
{
	Header1 := "PK" . Chr(5) . Chr(6)
	VarSetCapacity(Header2, 18, 0)
	file := FileOpen(zipFile,"w")
	file.Write(Header1)
	file.RawWrite(Header2,18)
	file.close()
}
