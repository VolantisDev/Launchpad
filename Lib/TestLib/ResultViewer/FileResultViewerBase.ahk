class FileResultViewerBase extends ResultViewerBase {
    outputFile := ""
    usesOutputFile := true
    fileExt := ""

    __New(title := "", outputFile := "", fileExt := "") {
        super.__New(title)
        
        if (fileExt) {
            this.fileExt := fileExt
        }

        if (!outputFile && this.usesOutputFile) {
            outputFile := A_Temp . "\test-results" . this.fileExt
        }

        this.outputFile := outputFile
    }

    ViewResults(results) {
        if (FileExist(this.outputFile)) {
            FileDelete(this.outputFile)
        }

        this.RenderResults(results)

        this.DisplayResults()
    }

    DisplayResults() {
        if (this.usesOutputFile) {
            if (FileExist(this.outputFile)) {
                Run(this.outputFile)
            } else {
                throw FileSystemTestException("Could not generate results file at " . this.outputFile)
            }
        }
    }

    RenderResults(results) {
        throw NotImplementedTestException("The RenderResults method has not been implemented.")
    }
}
