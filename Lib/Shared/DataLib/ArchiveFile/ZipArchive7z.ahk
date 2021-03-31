class ZipArchive7z extends ArchiveFileBase {
    ; TODO: Remove dependency on A_ScriptDir
    static 7za := A_ScriptDir . "\Vendor\7zip\" . (A_Is64bitOS ? "64bit" : "32bit") . "\7za.exe"

    Extract(destinationPath) {
        RunWait(ZipArchive7z.7za . " x `"" . this.archiveFile . "`" -o`"" . destinationPath . "\`" -y",, "Hide")
    }
}
