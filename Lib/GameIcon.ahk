class GameIcon {
    appDir := ""
    key := ""
    launcherDir := ""
    iconPathValue := ""

    IconPath[] {
        get {
            return this.iconPathValue
        }
        set {
            return this.iconPathValue := value
        }
    }

    __New(appDir, launcherDir, key, iconPath := "", autoPrepare := true) {
        this.appDir := appDir
        this.launcherDir := launcherDir
        this.key := key
        this.iconPathValue := iconPath

        if (autoPrepare) {
            this.PrepareGameIcon()
        }
    }

    AskGameIcon() {
        FileSelectFile, iconFile, 1,, % this.key . ": Select an icon file or an exe to extract the icon from", Icons (*.ico; *.exe; *.ocx; *.dll; *.cpl)
        if (iconFile == "") {
            MsgBox, "No icon selected."
            ExitApp, -1
        }

        return iconFile
    }

    CopyGameIcon(iconFile) {
        dest := this.launcherDir . "\" . this.key . ".ico"
        if (iconFile != dest) {
            FileCopy, %iconFile%, %dest%, true
        }
        return dest
    }

    ExtractGameIcon(exeFile) {
        dest := this.launcherDir . "\" . this.key . ".ico"
        iconsDir := this.launcherDir . "\icons"
        FileCreateDir, %iconsDir%
        appDir := this.appDir
        RunWait, %appDir%\Vendor\IconsExt\iconsext.exe /save "%exeFile%" "%iconsDir%" -icons,, Hide

        iconsCount := 0
        iconFile := ""
        glob := iconsDir . "\*.ico"
        Loop, %glob% {
            iconsCount := A_Index
            iconFile := A_LoopFilePath
        }  
        
        if (iconsCount == 0) {
            MsgBox, No icons could be extracted from %exeFile%.
            FileRemoveDir, %iconsDir%, true
            ExitApp, -1
        }

        if (iconsCount > 1) {
            iconFile := ""
            FileSelectFile, iconFile,, %iconsDir%, Select the correct icon from the extracted files, Icons (*.ico)
            if (iconFile == "") {
                MsgBox, "Canceled icon selection. Exiting."
                FileRemoveDir, %iconsDir%, true
                ExitApp, -1
            }
        }

        iconFile := this.CopyGameIcon(iconFile)
        FileRemoveDir, %iconsDir%, true
        return iconFile
    }

    PrepareGameIcon() {
        if (this.iconPathValue == "") {
            iconFile := this.launcherDir . "\" . this.key . ".ico"

            if (FileExist(iconFile)) {
                this.iconPathValue := iconFile
            } else {
                this.iconPathValue := this.AskGameIcon()
            }
        }

        SplitPath, % this.iconPathValue,,,iconExt
        if (iconExt != "ico") {
            this.iconPathValue := this.ExtractGameIcon(this.iconPathValue)
        }

        this.iconPathValue := this.CopyGameIcon(this.iconPathValue)
        return this.iconPathValue
    }
}
