#Warn

appDir := RegExReplace(A_ScriptDir, "\\[^\\]+$")

SplitPath(A_AhkPath,,ahkDir)

if (ahkDir == "") {
    ahkDir := appDir . "\Vendor\AutoHotKey"
}

buildDir := appDir . "\Build"
ahkScript := appDir . "\Launchpad.ahk"
exeFile := buildDir . "\Launchpad.exe"
iconFile := appDir . "\Graphics\Launchpad.ico"
zipPath := appDir . "\Launchpad.zip"
ahk2Exe := ahkDir . "\Compiler\Ahk2Exe.exe"

if (!FileExist(ahk2Exe)) {
    ahk2Exe := FileSelect(3,, "Please select your Ahk2Exe.exe file", "EXE Files (*.exe)")

    if (ahk2Exe == "") {
        MsgBox("Could not find Ahk2Exe.exe.")
        ExitApp -1
    }
}

if (DirExist(buildDir)) {
    DirDelete(buildDir, true)
}

DirCreate(buildDir)

pid := RunWait(ahk2Exe . " /in " . ahkScript . " /out " . exeFile . " /icon " . iconFile)

FileCopy(appDir . "\Launchers.json.sample", buildDir . "\Launchers.json.sample")
FileCopy(appDir . "\LICENSE.txt", buildDir . "\LICENSE.txt")
FileCopy(appDir . "\README.md", buildDir . "\README.md")
DirCopy(appDir . "\LauncherLib", buildDir . "\LauncherLib")

result := MsgBox("You may now modify the Build directory if needed. Click OK to build zip archive or Cancel to stop here.", "Post-Build Modification", "OC")
if (result == "Cancel") {
    ExitApp
}

Zip(buildDir, zipPath)
DirDelete(buildDir, true)

MsgBox("Finished building Launchpad! The archive is available at " . zipPath, "Launchpad Build Finished")
ExitApp

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
    Header2 := BufferAlloc(18)
	file := FileOpen(zipFile,"w")
	file.Write(Header1)
	file.RawWrite(Header2,18)
	file.close()



    Header1 := "PK" . Chr(5) . Chr(6)
	Header2 := BufferAlloc(18, 0)

	file := FileOpen(zipFile, "w")
	file.Write(Header1)
	file.RawWrite(Header2, 18)
	file.close()
}
