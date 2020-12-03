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

DirCreate(buildDir . "\Lib")
DirCopy(appDir . "\Lib\LauncherLib", buildDir . "\Lib\LauncherLib")
DirCopy(appDir . "\Lib\Shared", buildDir . "\Lib\Shared")
Zip(buildDir . "\Lib", buildDir . "\LaunchpadLib.zip")
DirDelete(buildDir . "\Lib", true)

Zip(appDir . "\Graphics", buildDir . "\LaunchpadGraphics.zip")
Zip(appDir . "\Themes", buildDir . "\LaunchpadThemes.zip")

BuildExe("LaunchpadUpdater", iconFile)
BuildExe("Launchpad", iconFile)

TrayTip("Finished building Launchpad.exe and LaunchpadUpdater.exe", "Launchpad Build", 1)
ExitApp

BuildExe(scriptName, iconFile) {
    global appDir, buildDir

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

    return RunWait(ahk2Exe . " /in `"" . appDir . "\" . scriptName . ".ahk`" /out `"" . buildDir . "\" . scriptName . ".exe`" /icon `"" . iconFile . "`"", appDir)
}

Zip(zipDir, zipFile, includeDir := false) {
    if (FileExist(zipFile)) {
        FileDelete(zipFile)
    }
    
    CreateZipFile(zipFile)

    psh := ComObjCreate("Shell.Application")
    pshZip := psh.Namespace(zipFile)

    if (!includeDir) {
        zipDir .= "\*"
    }

    Loop Files zipDir, "DF"
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
