class AhkIncludeWriter extends IncludeWriterBase {
    WriteIncludes(includes) {
        if (!this.outputPath) {
            throw AppException("Include file output path not specified")
        }

        if (FileExist(this.tmpPath)) {
            FileDelete(this.tmpPath)
        }

        FileAppend("; Automatically-generated file. Manual edits will be overwritten.`n", this.tmpPath)

        for index, includeFile in includes {
            FileAppend("#Include " . includeFile . "`n", this.tmpPath)
        }

        super.WriteIncludes(includes)
    }
}
