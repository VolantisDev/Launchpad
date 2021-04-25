class ArchiveFileBase {
    archiveFile := ""

    __New(archiveFile) {
        InvalidParameterException.CheckTypes("ArchiveFileBase", "archiveFile", archiveFile, "")
        InvalidParameterException.CheckEmpty("ArchiveFileBase", "archiveFile", archiveFile)
        this.archiveFile := archiveFile
    }

    /**
    * ABSTRACT METHODS
    */
    
    Extract(destinationPath) {
        throw(MethodNotImplementedException("ArchiveFileBase", "Extract"))
    }
}
