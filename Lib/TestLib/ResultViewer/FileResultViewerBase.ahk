class FileResultViewerBase extends ResultViewerBase {
    outputFile := ""
    fileExt := ""

    __New(outputFile := "", fileExt := "") {
        super.__New()
        
        if (fileExt) {
            this.fileExt := fileExt
        }

        if (!outputFile) {
            outputFile := A_Temp . "\test-results" . this.fileExt
        }
        this.outputFile := outputFile
    }

    ViewResults(results) {
        if (FileExist(this.outputFile)) {
            FileDelete(this.outputFile)
        }

        this.RenderResults(results)

        if (FileExist(this.outputFile)) {
            Run(this.outputFile)
        } else {
            throw AppException("Could not generate results file at " . this.outputFile)
        }
    }

    RenderResults(results) {
        throw MethodNotImplementedException("FileResultViewerBase", "RenderResults")
    }
}
