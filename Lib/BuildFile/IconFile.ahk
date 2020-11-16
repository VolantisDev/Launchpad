class IconFile extends CopyableBuildFile {
    requestMessage := "Select an icon file or an exe to extract the icon from"
    selectFilter := "Icons (*.ico; *.exe; *.ocx; *.dll; *.cpl)"

    __New(app, config, launcherDir, key, filePath := "", autoBuild := true) {
        sourcePath := config.HasKey("iconSrc") ? config.iconSrc : ""
        base.__New(app, config, launcherDir, key, ".ico", filePath, autoBuild, sourcePath)
    }

    Cleanup() {
        base.Cleanup()

        iconsDir := this.tempDir . "\icons"
        FileRemoveDir, %iconsDir%, true
    }

    Locate() {
        path := base.Locate()

        if (path != "") {
            SplitPath, path,,, fileExt

            if (fileExt != "ico") {
                path := this.ExtractGameIcon(path)
            }
        }

        return path
    }

    ExtractIcon(path) {
        iconsDir := this.tempDir . "\icons"
        iconsCount := 0
        iconFilePath := ""
        
        FileCreateDir, %iconsDir%
        RunWait, %appDir%\Vendor\IconsExt\iconsext.exe /save "%path%" "%iconsDir%" -icons,, Hide

        glob := iconsDir . "\*.ico"
        Loop, %glob% {
            iconsCount := A_Index
            iconFilePath := A_LoopFilePath
        }

        if (iconsCount == 0) {
            MsgBox, No icons count be extracted from %exeFile%.
            this.Cleanup()
            ExitApp, -1
        }

        if (iconsCount > 1) {
            iconFilePath := ""
            FileSelectFile, iconFilePath,, %iconsDir%, Select the correct icon from the extracted files, Icons (*.ico)

            if (iconFilePath == "") {
                MsgBox, "Canceled icon selection."
                this.Cleanup()
                ExitApp, -1
            }
        }

        this.sourcePath := iconFilePath
        return this.sourcePath
    }
}
