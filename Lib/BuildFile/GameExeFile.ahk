class GameExeFile extends ComposableBuildFile {
    __New(app, config, launcherDir, key, filePath := "", autoBuild := true) {
        base.__New(app, config, launcherDir, key, ".exe", filePath, autoBuild)
    }

    ComposeFile() {
        assetsDir := this.app.AppConfig.AssetsDir . "\" . this.key

        exePath := this.FilePath
        iconPath := assetsDir . "\" . this.key . ".ico"
        ahkPath := this.launcherDir . "\" . this.key . ".ahk"
        
        ahk2ExePath := this.app.AppConfig.AppDir . "\Vendor\AutoHotKey\Compiler\Ahk2Exe.exe"
        
        RunWait, %ahk2ExePath% /in "%ahkPath%" /out "%exePath%" /icon "%iconPath%"
    }
}
