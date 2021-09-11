class HtmlResultViewer extends TemplateFileResultViewerBase {
    fileExt := ".html"

    RenderResultItems(results) {
        output := ""

        for testKey, testResults in results {
            output .= "<div class='row test-results'>`n"
            output .= this.RenderTestTitle(testKey)
            output .= this.RenderTestSummary(testResults)
            output .= this.RenderTestResults(testResults)
            output .= "</div>`n"
        }

        return output
    }

    RenderTestTitle(testKey) {
        return "<h2>" . testKey . "</h2>`n"
    }

    RenderTestSummary(testResults) {
        testStatus := "Successful"
        successful := true
        succeededCount := 0
        totalCount := testResults.Count

        for taskName, taskResult in testResults {
            if (taskResult["success"]) {
                succeededCount += 1
            } else {
                successful := false
                testStatus := "Failed"
            }
        }

        output := "<dl>`n"
        output .= "`t<dt>Status</dt>`n"
        statusClass := successful ? "text-success" : "text-danger"
        output .= "`t<dd class='" . statusClass . "'>" . testStatus . "</dd>`n"
        output .= "`t<dt>Succeeded</dt>`n"
        output .= "`t<dd>" . succeededCount . "/" . totalCount . "</dd>`n"
        output .= "</dl>`n"
        return output
    }

    RenderTestResults(testResults) {
        output := "<table class='table table-bordered'>`n"
        output .= "`t<tr><th scope='col'>Task</th><th scope='col'>Assertion</th><th scope='col'>Status</th><th scope='col'>Data</th></tr>`n"

        for taskName, taskResult in testResults {
            dataOutput := ""

            if (taskResult.Has("data") && taskResult["data"].Count > 0) {
                dataOutput .= "<dl>"
                for dataKey, dataValue in taskResult["data"] {
                    dataOutput .= "<dt>" . dataKey . "</dt><dd>" . this.ConvertToString(dataValue) . "</dd>"
                }
                dataOutput .= "</dl>"
            }

            className := taskResult["success"] ? "table-success" : "table-danger"
            taskStatus := taskResult["success"] ? "Success" : "Failure"

            output .= "`t<tr class='" . className . "'>`n"
            output .= "`t`t<th scope='row'>" . taskName . "</th>`n"
            output .= "`t`t<td>" . taskResult["assertion"] . "</td>`n"
            output .= "`t`t<td>" . taskStatus . "</td>`n"
            output .= "`t`t<td>" . dataOutput . "</td>`n"
            output .= "`t</tr>`n"
        }

        output .= "</table>`n"

        return output
    }
}
