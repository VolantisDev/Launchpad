class IncludeWriterBase {
    outputPath := ""
    tmpPath := ""

    __New(outputPath) {
        this.outputPath := outputPath
        this.tmpPath := outputPath . ".tmp"
    }

    /*
        Write to this.tmpPath in your implementation, and then call
        this super method which will compare the files and move the
        tmp file into the regular outputPath or delete it if identical
    */
    WriteIncludes(includes) {
        if (!FileExist(this.outputPath) && !includes.Length) {
            FileDelete(this.tmpPath)
            return false
        }

        updated := true

        if (FileExist(this.tmpPath)) {
            if (FileExist(this.outputPath)) {
                updated := this.FilesAreDifferent(this.tmpPath, this.outputPath)

                if (updated) {
                    try {
                        FileDelete(this.outputPath)
                    } catch Any {
                        throw AppException("Unable to delete file path " . this.outputPath)
                    }
                    
                }
            }

            if (updated) {
                FileMove(this.tmpPath, this.outputPath)
            } else {
                FileDelete(this.tmpPath)
            }
        }
        
        return updated
    }

    FilesAreDifferent(firstFile, secondFile) {
        content1 := FileRead(firstFile)
        content2 := FileRead(secondFile)

        return content1 != content2
    }
}
