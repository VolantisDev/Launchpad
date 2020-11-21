class IconFile extends CopyableBuildFile {
    requestMessage := "Select an icon file or an exe to extract the icon from"
    selectFilter := "Icons (*.ico; *.exe; *.ocx; *.dll; *.cpl)"

    __New(app, config, launcherDir, key, filePath := "") {
        sourcePath := config.Has("iconSrc") ? config["iconSrc"] : ""
        super.__New(app, config, launcherDir, key, ".ico", filePath, sourcePath)
    }

    Cleanup() {
        super.Cleanup()
        if (DirExist(this.tempDir . "\icons")) {
            DirDelete(this.tempDir . "\icons", true)
        }
        
        return true
    }

    Locate() {
        path := super.Locate()

        if (path != "") {
            SplitPath(path,,, fileExt)

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
        
        DirCreate(iconsDir)
        pid := RunWait(iconsExtPath . " /save " . path . " " . iconsDir . " -icons",, "Hide")

        iconsCount := 0
        glob := iconsDir . "\*.ico"
        Loop Files glob {
            iconsCount := A_Index
            iconFilePath := A_LoopFilePath
        }

        if (iconsCount == 0) {
            this.app.Toast("No icons could be extracted from %exeFile%. Please try another file.", "Launchpad", 10, 2)
            iconFilePath := ""
            this.Cleanup()
        } else {
            if (iconsCount > 1) {
                iconFilePath := FileSelect(, iconsDir, "Select the correct icon from the extracted files", "Icons (*.ico)")
                
                if (iconFilePath == "") {
                    this.app.Toast("Canceled icon selection. Please try again.", "Launchpad", 10, 2)
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
