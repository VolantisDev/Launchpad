class TemplateFileResultViewerBase extends FileResultViewerBase {
    templateFile := ""

    __New(templateFile, outputFile := "", fileExt := "") {
        this.templateFile := templateFile
        super.__New(outputFile, fileExt)
    }

    RenderResults(results) {
        if (!this.templateFile) {
            throw AppException("No template file provided for rendering results.")
        }

        template := FileRead(this.templateFile)
        content := StrReplace(template, "{{results}}", this.RenderResultItems(results))

        if (FileExist(this.outputFile)) {
            FileDelete(this.outputFile)
        }

        FileAppend(content, this.outputFile)
    }

    RenderResultItems(results) {
        throw MethodNotImplementedException("TemplateFileResultViewerBase", "RenderResultItems")
    }
}
