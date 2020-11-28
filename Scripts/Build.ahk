#Warn

appDir := RegExReplace(A_ScriptDir, "\\[^\\]+$")



buildDir := appDir . "\Build"
ahkScript := appDir . "\Launchpad.ahk"
exeFile := buildDir . "\Launchpad.exe"
iconFile := appDir . "\Graphics\Launchpad.ico"
zipPath := appDir . "\Launchpad.zip"


if (DirExist(buildDir)) {
    DirDelete(buildDir, true)
}

DirCreate(buildDir)
ZipLibDir("LauncherLib")
ZipLibDir("SharedLib", "Shared")
BuildExe("Launchpad Updater", iconFile)
BuildExe("Launchpad", iconFile)
DirDelete(buildDir, true)

TrayTip("Finished building Launchpad.exe and Launchpad Updater.exe", "Launchpad Build", 1)
ExitApp

BuildExe(scriptName, iconFile) {
    global appDir

    SplitPath(A_AhkPath,, ahkDir)

    if (ahkDir == "") {
        ahkDir := appDir . "\Vendor\AutoHotKey"
    }

    ahk2Exe := ahkDir . "\Compiler\Ahk2Exe.exe"

    if (!FileExist(ahk2Exe)) {
        ahk2Exe := FileSelect(3,, "Please select your Ahk2Exe.exe file", "EXE Files (*.exe)")

        if (ahk2Exe == "") {
            MsgBox("Could not find Ahk2Exe.exe.")
            ExitApp -1
        }
    }

    return RunWait(ahk2Exe . " /in " . appDir . "\" . scriptName . ".ahk" . " /out " . appDir . "\" . scriptName . ".exe" . " /icon " . iconFile)
}

ZipLibDir(name, libDir := "") {
    global appDir

    if (libDir == "") {
        libDir := name
    }

    Zip(appDir . "\Lib\" . name, buildDir . "\" . name . ".zip")
}

Zip(zipDir, zipFile) {
    if (FileExist(zipFile)) {
        FileDelete(zipFile)
    }
    
    CreateZipFile(zipFile)

    psh := ComObjCreate("Shell.Application")
    pshZip := psh.Namespace(zipFile)

    Loop Files zipDir . "\*", "DF"
    {
        Sleep(1000)
        pshZip.CopyHere(A_LoopFileFullPath, 4|16)
    }

    Sleep(2000)
}

CreateZipFile(zipFile)
{
	Header1 := "PK" . Chr(5) . Chr(6)
	Header2 := BufferAlloc(18, 0)

	file := FileOpen(zipFile, "w")
	file.Write(Header1)
	file.RawWrite(Header2, 18)
	file.close()
}
