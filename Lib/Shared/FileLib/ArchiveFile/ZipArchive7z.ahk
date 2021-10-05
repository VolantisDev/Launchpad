class ZipArchive7z extends ArchiveFileBase {
    ; TODO: Remove dependency on A_ScriptDir
    7za := ""

    __New(archiveFile, scriptDir := "") {
        if (!scriptDir) {
            scriptDir := A_ScriptDir
        }

        this.7za := scriptDir . "\Vendor\7zip\" . (A_Is64bitOS ? "64bit" : "32bit") . "\7za.exe"

        super.__New(archiveFile)
    }

    Extract(destinationPath) {
        RunWait(this.7za . " x `"" . this.archiveFile . "`" -o`"" . destinationPath . "\`" -y",, "Hide")
    }

    Compress(pattern, dir := "") {
        if (!dir) {
            dir := A_WorkingDir
        }

        RunWait(this.7za . " a `"" . this.archiveFile . "`" `"" . pattern . "`" -y", dir, "Hide")
    }
}
