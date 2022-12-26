class ZipArchive7z extends ArchiveFileBase {
    ; TODO: Remove dependency on A_ScriptDir
    exePath := ""

    __New(archiveFile, scriptDir := "") {
        if (!scriptDir) {
            scriptDir := A_ScriptDir
        }

        this.exePath := scriptDir . "\Vendor\7zip\" . (A_Is64bitOS ? "64bit" : "32bit") . "\7za.exe"

        super.__New(archiveFile)
    }

    Extract(destinationPath) {
        RunWait(this.exePath . " x `"" . this.archiveFile . "`" -o`"" . destinationPath . "\`" -y",, "Hide")
    }

    Compress(pattern, dir := "") {
        if (!dir) {
            dir := A_WorkingDir
        }

        RunWait(this.exePath . " a `"" . this.archiveFile . "`" `"" . pattern . "`" -y", dir, "Hide")
    }
}
