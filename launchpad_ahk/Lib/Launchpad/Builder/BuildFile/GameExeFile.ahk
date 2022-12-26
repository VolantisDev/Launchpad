class GameExeFile extends ComposableBuildFile {
    __New(launcherEntityObj, destPath := "") {
        if (destPath == "") {
            destPath := launcherEntityObj["DestinationDir"] . "\" . launcherEntityObj.Id . ".exe"
        }

        super.__New(launcherEntityObj, destPath)
    }

    ComposeFile() {
        iconPath := this.launcherEntityObj["AssetsDir"] . "\" . this.launcherEntityObj.Id . ".ico"
        ahkPath := this.launcherEntityObj["AssetsDir"] . "\" . this.launcherEntityObj.Id . ".ahk"
        ahkExe := this.appDir . "\Vendor\AutoHotKey\AutoHotkey" . (A_Is64bitOS ? "64" : "32") . ".exe"
        ahk2ExePath := this.appDir . "\Vendor\AutoHotKey\Compiler\Ahk2Exe.exe"

        SplitPath(ahk2ExePath,, &ahk2ExeDir)
        
        pid := RunWait(ahk2ExePath . " /in `"" . ahkPath . "`" /out `"" . this.FilePath . "`" /icon `"" . iconPath . "`" /bin `"" . ahkExe . "`"", ahk2ExeDir)

        return this.FilePath
    }
}
