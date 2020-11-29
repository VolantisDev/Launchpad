class GameExeFile extends ComposableBuildFile {
    __New(app, launcherEntityObj, launcherDir, key, filePath := "") {
        super.__New(app, launcherEntityObj, launcherDir, key, ".exe", filePath)
    }

    ComposeFile() {
        assetsDir := this.app.Config.AssetsDir . "\" . this.key

        exePath := this.FilePath
        iconPath := assetsDir . "\" . this.key . ".ico"
        ahkPath := assetsDir . "\" . this.key . ".ahk"
        
        ahk2ExePath := this.appDir . "\Vendor\AutoHotKey\Compiler\Ahk2Exe.exe"

        SplitPath(ahk2ExePath,,ahk2ExeDir)
        
        pid := RunWait(ahk2ExePath . " /in `"" . ahkPath . "`" /out `"" . exePath . "`" /icon `"" . iconPath . "`"", ahk2ExeDir)

        return this.FilePath
    }
}
