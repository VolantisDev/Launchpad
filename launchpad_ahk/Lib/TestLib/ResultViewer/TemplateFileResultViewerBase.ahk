class TemplateFileResultViewerBase extends FileResultViewerBase {
    rendered := ""
    templateContent := ""

    __New(title := "", templateContent := "", outputFile := "", fileExt := "") {
        this.templateContent := templateContent
        super.__New(title, outputFile, fileExt)
    }

    SetTemplate(templateContent) {
        this.templateContent := templateContent
        return this
    }

    RenderResults(results) {
        if (!this.templateContent) {
            throw TestException("No template provided for rendering results.")
        }

        content := this.templateContent
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
