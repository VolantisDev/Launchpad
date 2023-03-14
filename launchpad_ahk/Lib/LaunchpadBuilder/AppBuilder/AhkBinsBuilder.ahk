class AhkBinsBuilder extends AppBuilderBase {
    name := "AHK Bins"

    Build(version) {
        buildFile := this.app.appDir . "\Resources\Dependencies\AhkBins.zip"

        this.Backup(buildFile, true)
        success := this.Generate(buildFile)
        this.Cleanup(buildFile)

        return success
    }

    Backup(buildFile, deleteBuildFile := false) {
        bakFile := buildFile . ".bak"

        if (FileExist(buildFile)) {
            if (deleteBuildFile) {
                FileMove(buildFile, bakFile, true)
            } else {
                FileCopy(buildFile, bakFile, true)
            }
        }
    }

    Generate(buildFile) {
        sourceDir := this.app.appDir . "\Vendor\AutoHotKey\Compiler"
        files := ["Ahk2Exe.exe", "mpress.exe"]

        if (FileExist(buildFile)) {
            FileDelete(buildFile)
        }

        archive := ZipArchive7z(buildFile, this.app.appDir)
        archive.Compress(sourceDir . "\*.exe", sourceDir)

        ; TODO: Make sure that the zip file was successfully created
        return !!(FileExist(buildFile))
    }

    Cleanup(buildFile) {
        bakFile := buildFile . ".bak"

        if (FileExist(bakFile)) {
            if (FileExist(buildFile)) {
                FileDelete(bakFile)
            } else {
                FileMove(bakFile, buildFile, true)
            }
        }
    }
}
