class ZipArchive extends ArchiveFileBase {
    static psh := ComObjCreate("Shell.Application")

    Extract(destinationPath) {
        archiveItems := DependencyBase.psh.Namespace(this.archiveFile).items
        DependencyBase.psh.Namespace(destinationPath).CopyHere(archiveItems, 4|16)
    }
}
