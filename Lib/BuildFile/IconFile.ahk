class IconFile extends CopyableBuildFile {
    requestMessage := "Select an icon file or an exe to extract the icon from"
    selectFilter := "Icons (*.ico; *.exe; *.ocx; *.dll; *.cpl)"

    __New(app, config, launcherDir, key, filePath := "") {
        sourcePath := config.HasKey("iconSrc") ? config.iconSrc : ""
        base.__New(app, config, launcherDir, key, ".ico", filePath, sourcePath)
    }

    Cleanup() {
        base.Cleanup()

        iconsDir := this.tempDir . "\icons"
        FileRemoveDir, %iconsDir%, true

        return true
    }

    Locate() {
        path := base.Locate()

        if (path != "") {
            SplitPath, path,,, fileExt

            if (fileExt != "ico") {
                path := this.ExtractIcon(path)

                if (path == "") {
                    this.Locate()
                }
            }
        }

        return path
    }

    ExtractIcon(path) {
        iconsDir := this.tempDir . "\icons"
        
        iconFilePath := ""
        iconsExtPath := this.appDir . "\Vendor\IconsExt\iconsext.exe"
        
        FileCreateDir, %iconsDir%
        RunWait, %iconsExtPath% /save "%path%" "%iconsDir%" -icons,, Hide

        iconsCount := 0
        glob := iconsDir . "\*.ico"
        Loop, %glob% {
            iconsCount := A_Index
            iconFilePath := A_LoopFilePath
        }

        if (iconsCount == 0) {
            this.app.Toast("No icons could be extracted from %exeFile%. Please try another file.", "LauncherGen", 10, 2)
            iconFilePath := ""
            this.Cleanup()
        } else {
            if (iconsCount > 1) {
                iconFilePath := ""
                FileSelectFile, iconFilePath,, %iconsDir%, Select the correct icon from the extracted files, Icons (*.ico)

                if (iconFilePath == "") {
                    this.app.Toast("Canceled icon selection. Please try again.", "LauncherGen", 10, 2)
                    this.Cleanup()
                }
            }
        }

        if (iconFilePath != "") {
            this.sourcePath := iconFilePath
        }

        return iconFilePath
    }
}
