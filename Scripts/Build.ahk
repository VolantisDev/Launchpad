#Warn
#Persistent

#Include ..\Lib\Shared\Includes.ahk

appDir := RegExReplace(A_ScriptDir, "\\[^\\]+$")
makensis := BuildConfig("makensis", "C:\Program Files (x86)\NSIS\makensis.exe")
githubUsername := BuildConfig("github_username", "")
githubToken := BuildConfig("github_token", "")
repoName := BuildConfig("repo_name", "VolantisDev/Launchpad")
buildDir := appDir . "\Build"
iconFile := appDir . "\Resources\Graphics\Launchpad.ico"
appVersion := GetLatestVersionTag()
copyLibs := ["Shared", "LaunchpadLauncher"]
copyVendorLibs := ["7zip"]

inputResult := InputBox("This is the version of Launchpad that will be built. Entering a different version will create (but not necessarily push) a new git tag for you.", "Launchpad Build Version",, appVersion)

if (!inputResult) {
    ExitApp()
}

if (inputResult.Value != appVersion) {
    appVersion := inputResult.Value
    CreateGitTag(appVersion)
}

ResetBuildDir()
DirCreate(buildDir . "\Lib")

for buildIndex, libName in copyLibs {
    DirCopy(appDir . "\Lib\" . libName, buildDir . "\Lib\" . libName)
}

DirCopy(appDir . "\Resources", buildDir . "\Resources")
DirCreate(buildDir . "\Vendor")

for buildIndex, libName in copyVendorLibs {
    DirCopy(appDir . "\Vendor\" . libName, buildDir . "\Vendor\" . libName)
}

BuildExe("Launchpad", iconFile)
GenerateInstaller()

Sleep(50)

DirDelete(buildDir . "\Lib", true)
DirDelete(buildDir . "\Resources", true)
DirDelete(buildDir . "\Vendor", true)
FileDelete(buildDir . "\Launchpad.exe")

Run(buildDir)

if (githubUsername && githubToken) {
    Sleep(1000)
    ShowReleaseInfoGui()
} else {
    MsgBox("If you wish to submit a new Launchpad release, create a Launchpad.build.ini file containing at least a github_username and github_token.", "GitHub token missing")
}

TrayTip("Finished building Launchpad!", "Launchpad Build", 1)

ShowReleaseInfoGui() {
    global appVersion
    releaseInfoGui := Gui.new(, "Launchpad Release Information")
    releaseInfoGui.AddText(, "Release Title:")
    releaseInfoGui.AddEdit("vReleaseTitle w550", "Launchpad " . appVersion)
    releaseInfoGui.AddText(, "Release Details:")
    releaseInfoGui.AddEdit("vReleaseDetails w550 r10")
    releaseInfoGui.AddCheckBox("vDraft", "Create as draft")
    releaseInfoGui.AddCheckBox("vPrerelease", "Mark as prerelease")

    releaseInfoBtn := releaseInfoGui.AddButton("Default xm", "&Submit")
    releaseInfoBtn.OnEvent("Click", "ProcessReleaseInfo")
    releaseInfoBtn.GuiWindow := releaseInfoGui

    cancelBtn := releaseInfoGui.AddButton("x+m yp", "Cancel")
    cancelBtn.OnEvent("Click", "CancelRelease")

    releaseInfoGui.Show()
}

CancelRelease(btn, info) {
    ExitApp()
}

ProcessReleaseInfo(btn, info) {
    global githubUsername, githubToken, repoName, appVersion
    data := btn.GuiWindow.Submit()

    PushGitTag(appVersion)

    postData := Map()
    postData["tag_name"] := appVersion
    postData["name"] := data.ReleaseTitle
    postData["body"] := data.ReleaseDetails
    postData["draft"] := True ; !!(data.Draft)
    postData["prerelease"] := !!(data.Prerelease)

    url := "https://api.github.com/repos/" . repoName . "/releases"
    request := WinHttpReq.new(url)
    request.requestHeaders["Authorization"] := "Basic " . Base64Encode(githubUsername . ":" . githubToken)
    response := request.Send("POST", postData)
    success := !!(response == -1 && request.GetStatusCode() == 200)
    responseData := request.GetResponseData()

    if (success && responseData) {
        json := JsonData.new()
        responseObj := json.FromString(responseData)

        if (responseObj.Has("upload_url") && responseObj["upload_url"]) {
            success := UploadInstaller(responseObj["upload_url"])

            if (success) {
                PushReleaseToLaunchpadApi(postData)
            }
        }
    } else {
        MsgBox("Release submission failed. You may need to do this one by hand. Response:`n`n" . request.GetResponseData())
    }

    Run("https://github.com/" . repoName . "/releases/tag/" . appVersion)
}

PushReleaseToLaunchpadApi(data) {
    global githubUsername, githubToken, repoName, appVersion

    apiUrl := "https://api.launchpad.games/v1/release-info"

    MsgBox("Release info pushing is not yet available. Please update release info manually.")
    Run("https://console.firebase.google.com/u/0/project/launchpad-306703/firestore/data~2Frelease-info~2Fstable")
}

UploadInstaller(uploadUrl) {
    global githubUsername, githubToken, repoName, appVersion, buildDir

    installer := buildDir . "\Launchpad-" . appVersion . ".exe"

    success := false

    if (FileExist(installer)) {
        request := WinHttpReq.new(uploadUrl)
        request.requestHeaders["Authorization"] := "Basic " . Base64Encode(githubUsername . ":" . githubToken)
        request.requestHeaders["Content-Length"] := FileGetSize(installer)
        request.requestHeaders["Content-Type"] := "application/vnd.microsoft.portable-executable"

        response := request.Send("POST", installer, true)
        success := !!(response == -1 && request.GetStatusCode() == 200)
    }

    return success
}

Base64Encode(ByRef data, len := -1, ByRef out := "") {
    bytesPerChar := 2

    if (Round(len) <= 0) {
        len := StrLen(data) * 2
    }

    result := ""
    dll := "Crypt32\CryptBinaryToString"

    sizeBuf := BufferAlloc(8, 0)

    ; if DllCall(dll, "Ptr", StrPtr(data), "UInt", len, "UInt", 0x00000001, "Ptr", 0, "UIntP", sizeBuf.Ptr) {
    ;     size := NumGet(sizeBuf, 0, "UInt")
    ;     out := BufferAlloc(size *= bytesPerChar, 0)

	; 	if DllCall(dll, "Ptr", StrPtr(data), "UInt", len, "UInt", 0x00000001, "Ptr", out, "UIntP", sizeBuf.Ptr) {
    ;         size := NumGet(sizeBuf, 0, "UInt")
    ;         result := size * BytesPerChar
    ;         MsgBox(result)
    ;     }
	; }

    return result
}

BuildConfig(key, defaultValue) {
    global appDir
    buildIni := appDir . "\Launchpad.build.ini"

    value := defaultValue

    if (FileExist(buildIni)) {
        value := IniRead(buildIni, "General", key, defaultValue)
    }

    return value
}

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
            PushGitTag(tagName)
        }
    }
}

PushGitTag(tagName) {
    global appDir
    RunWait("git push origin " . tagName, appDir)
}

GenerateInstaller() {
    global appDir, makensis, appVersion, buildDir
    RunWait(makensis . " /DVERSION=" . appVersion . ".0 Launchpad.nsi", appDir)

    if (FileExist(buildDir . "\LaunchpadInstaller.exe")) {
        FileMove(buildDir . "\LaunchpadInstaller.exe", buildDir . "\Launchpad-" . appVersion . ".exe")
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
    global appDir, buildDir, appVersion

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
    scriptContent := StrReplace(scriptContent, "{{VERSION}}", appVersion)
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
