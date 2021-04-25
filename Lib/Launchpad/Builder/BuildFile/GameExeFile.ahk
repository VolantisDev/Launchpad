class GameExeFile extends ComposableBuildFile {
    __New(launcherEntityObj, destPath := "") {
        if (destPath == "") {
            destPath := launcherEntityObj.DestinationDir . "\" . launcherEntityObj.Key . ".exe"
        }

        super.__New(launcherEntityObj, destPath)
    }

    ComposeFile() {
        iconPath := this.launcherEntityObj.AssetsDir . "\" . this.launcherEntityObj.Key . ".ico"
        ahkPath := this.launcherEntityObj.AssetsDir . "\" . this.launcherEntityObj.Key . ".ahk"
        ahk2ExePath := this.appDir . "\Vendor\AutoHotKey\Compiler\Ahk2Exe.exe"

        SplitPath(ahk2ExePath,, &ahk2ExeDir)
        
        pid := RunWait(ahk2ExePath . " /in `"" . ahkPath . "`" /out `"" . this.FilePath . "`" /icon `"" . iconPath . "`"", ahk2ExeDir)

        return this.FilePath
    }
}
