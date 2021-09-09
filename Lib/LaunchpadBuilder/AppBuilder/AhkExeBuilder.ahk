class AhkExeBuilder extends AppBuilderBase {
    name := "Exe"
    copyLibs := ["Shared", "LaunchpadLauncher"]
    copyVendorLibs := ["7zip"]

    Build(version) {
        buildDir := this.app.Config.BuildDir
        this.ResetBuildDir(buildDir)
        this.CopyLibraries(buildDir)
        this.CopyResources(buildDir)
        this.CopyVendorLibraries(buildDir)
        result := this.BuildExe(buildDir)

        if (this.app.Config.OpenBuildDir) {
            Run(buildDir)
        }

        return result
    }

    ResetBuildDir(buildDir) {
        if (DirExist(buildDir)) {
            DirDelete(buildDir, true)
        }

        DirCreate(buildDir)
    }

    CopyLibraries(buildDir) {
        DirCreate(buildDir . "\Lib")

        for buildIndex, libName in this.copyLibs {
            DirCopy(this.app.appDir . "\Lib\" . libName, buildDir . "\Lib\" . libName)
        }
    }

    CopyResources(buildDir) {
        DirCopy(this.app.appDir . "\Resources", buildDir . "\Resources")
    }

    CopyVendorLibraries(buildDir) {
        DirCreate(buildDir . "\Vendor")

        for buildIndex, libName in this.copyVendorLibs {
            DirCopy(this.app.appDir . "\Vendor\" . libName, buildDir . "\Vendor\" . libName)
        }
    }

    BuildExe(buildDir) {
        SplitPath(A_AhkPath,, &ahkDir)

        if (ahkDir == "") {
            ahkDir := this.app.appDir . "\Vendor\AutoHotKey"
        }

        ahkExe := this.app.appDir . "\Vendor\AutoHotKey\AutoHotkey" . (A_Is64bitOS ? "64" : "32") . ".exe"
        ahk2Exe := ahkDir . "\Compiler\Ahk2Exe.exe"

        if (!FileExist(ahk2Exe)) {
            ahk2Exe := FileSelect(3,, "Please select your Ahk2Exe.exe file", "EXE Files (*.exe)")

            if (ahk2Exe == "") {
                throw AppException("Could not find Ahk2Exe.exe")
            }
        }

        scriptContent := FileRead(this.app.appDir . "\" . this.app.appName . ".ahk")
        scriptContent := StrReplace(scriptContent, "{{VERSION}}", this.app.Version)
        buildFile := this.app.appDir . "\" . this.app.appName . "-build.ahk"
        exeFile := buildDir . "\" . this.app.appName . ".exe"

        if (FileExist(buildFile)) {
            FileDelete(buildFile)
        }

        FileAppend(scriptContent, buildFile)
        runResult := RunWait(ahk2Exe . " /in `"" . buildFile . "`" /out `"" . exeFile . "`" /icon `"" . this.app.Config.IconFile . "`" /bin `"" . ahkExe . "`"", this.app.appDir)
        FileDelete(buildFile)

        return runResult
    }
}
