class IconFile extends CopyableBuildFile {
    requestMessage := "Select an icon file or an exe to extract the icon from"
    selectFilter := "Icons (*.ico; *.exe; *.ocx; *.dll; *.cpl)"

    __New(app, launcherGameObj, launcherDir, key, filePath := "") {
        super.__New(app, launcherGameObj, launcherDir, key, ".ico", filePath, launcherGameObj.IconSrc)
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
            this.app.Notifications.Warning("No icons could be extracted from %exeFile%. Please try another file.")
            iconFilePath := ""
            this.Cleanup()
        } else {
            if (iconsCount > 1) {
                iconFilePath := FileSelect(, iconsDir, "Select the correct icon from the extracted files", "Icons (*.ico)")
                
                if (iconFilePath == "") {
                    this.app.Notifications.Warning("Canceled icon selection. Please try again.")
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
