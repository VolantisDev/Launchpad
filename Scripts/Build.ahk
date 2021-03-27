#Warn

makensis := "C:\Program Files (x86)\NSIS\makensis.exe"
appDir := RegExReplace(A_ScriptDir, "\\[^\\]+$")
buildDir := appDir . "\Build"
iconFile := appDir . "\Resources\Graphics\Launchpad.ico"
version := GetLatestVersionTag()

result := InputBox("This is the version of Launchpad that will be built. Entering a different version will create (but not push) a new git tag for you.", "Launchpad Build Version",, version)

if (result.Value != version) {
    version := result.Value
    CreateGitTag(version)
}

ResetBuildDir()
DirCreate(buildDir . "\Lib")
DirCopy(appDir . "\Lib\Shared", buildDir . "\Lib\Shared")
DirCopy(appDir . "\Lib\LaunchpadLauncher", buildDir . "\Lib\LaunchpadLauncher")
DirCopy(appDir . "\Resources", buildDir . "\Resources")
DirCreate(buildDir . "\Vendor")
DirCopy(appDir . "\Vendor\7zip", buildDir . "\Vendor\7zip")
BuildExe("Launchpad", iconFile)
GenerateInstaller()
DirDelete(buildDir . "\Lib", true)
DirDelete(buildDir . "\Resources", true)
DirDelete(buildDir . "\Vendor", true)
FileDelete(buildDir . "\Launchpad.exe")

Run(buildDir)
TrayTip("Finished building Launchpad!", "Launchpad Build", 1)
ExitApp

GetLatestVersionTag() {
    return Trim(GetCommandOutput("git describe --tags --abbrev=0"), " `r`n`t")
}

CreateGitTag(tagName) {
    global appDir
    tagExists := GetCommandOutput("git show-ref " . tagName)

    if (tagExists == "") {
        RunWait("git tag " . tagName, appDir)

        push := MsgBox("Created new tag `"" . tagName . "`" in local git repository. Would you like to push this tag to origin now?", "Git Tag Created", "YesNo")

        if (push == "Yes") {
            RunWait("git push origin " . tagName, appDir)
        }
    }
}

GenerateInstaller() {
    global appDir, makensis, version, buildDir
    RunWait(makensis . " /DVERSION=" . version . ".0 Launchpad.nsi", appDir)

    if (FileExist(buildDir . "\LaunchpadInstaller.exe")) {
        FileMove(buildDir . "\LaunchpadInstaller.exe", buildDir . "\Launchpad-" . version . ".exe")
    }
}

GetCommandOutput(command) {
    global appDir
    shell := ComObjCreate("WScript.Shell")
    shell.CurrentDirectory := appDir
    exec := shell.Exec(A_ComSpec " /C " command)
    return exec.StdOut.ReadAll()
}

ResetBuildDir() {
    global buildDir
    if (DirExist(buildDir)) {
        DirDelete(buildDir, true)
    }

    DirCreate(buildDir)
}

BuildExe(scriptName, iconFile) {
    global appDir, buildDir, version

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

    scriptContent := FileRead(appDir . "\" . scriptName . ".ahk")
    scriptContent := StrReplace(scriptContent, "{{VERSION}}", version)
    buildFile := appDir . "\" . scriptName . "-build.ahk"
    exeFile := buildDir . "\" . scriptName . ".exe"

    if (FileExist(buildFile)) {
        FileDelete(buildFile)
    }

    FileAppend(scriptContent, buildFile)
    runResult := RunWait(ahk2Exe . " /in `"" . buildFile . "`" /out `"" . exeFile . "`" /icon `"" . iconFile . "`"", appDir)
    FileDelete(buildFile)
    return runResult
}

Zip(zipDir, zipFile, includeDir := false) {
    if (FileExist(zipFile)) {
        FileDelete(zipFile)
    }
    
    ; @todo Replace with ZipArchive7z class usage?
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
