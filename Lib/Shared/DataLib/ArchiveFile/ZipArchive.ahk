class ZipArchive extends ArchiveFileBase {
    static psh := ComObjCreate("Shell.Application")

    Extract(destinationPath) {
        archiveItems := ZipArchive.psh.Namespace(this.archiveFile).items
        ZipArchive.psh.Namespace(destinationPath).CopyHere(archiveItems, 4|16)
    }
}
