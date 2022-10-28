class TemplateFileResultViewerBase extends FileResultViewerBase {
    templateFile := ""
    rendered := ""

    __New(templateFile, outputFile := "", fileExt := "") {
        this.templateFile := templateFile
        super.__New(outputFile, fileExt)
    }

    RenderResults(results) {
        if (!this.templateFile) {
            throw TestException("No template file provided for rendering results.")
        }

        content := FileRead(this.templateFile)
        content := StrReplace(content, "{{title}}", this.testTitle)
        content := StrReplace(content, "{{results}}", this.RenderResultItems(results))

        this.StoreRenderedResults(content)
    }

    StoreRenderedResults(output) {
        if (this.usesOutputFile) {
            if (FileExist(this.outputFile)) {
                FileDelete(this.outputFile)
            }

            FileAppend(output, this.outputFile)
        } else {
            this.rendered := output
        }
    }

    RenderResultItems(results) {
        throw NotImplementedTestException("The RenderResultItems method has not been implemented.")
    }
}
