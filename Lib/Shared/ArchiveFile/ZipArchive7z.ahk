class ZipArchive7z extends ArchiveFileBase {
    static 7za := A_ScriptDir . "\Vendor\7zip\" . (FileExist("C:\Program Files (x86)") ? "64bit" : "32bit") . "\7za.exe"

    Extract(destinationPath) {
        RunWait(ZipArchive7z.7za . " e `"" . this.archiveFile . "`" -o`"" . destinationPath . "\`" -y",, "Hide")
    }
}
