class HtmlResultViewer extends TemplateFileResultViewerBase {
    fileExt := ".html"

    RenderResultItems(results) {
        allResults := []

        for testKey, testResults in results {
            if (testResults.Length) {
                for innerKey, innerResult in testResults {
                    allResults.Push(innerResult)
                }
            }
        }

        output := "<div class='row test-summary'>`n"
        output .= this.RenderTestTitle("Test Summary")
        output .= this.RenderTestSummary(allResults)
        output .= "</div>`n"

        output .= "<div class='accordion' id='results-accordion'>`n"

        panelNum := 0

        for testKey, testResults in results {
            if (testResults.Length) {
                panelNum += 1

                succeeded := this.TestSucceeded(testResults)
                icon := succeeded ? 'check-circle-fill' : 'exclamation-circle-fill'
                color := succeeded ? 'text-success' : 'text-danger'
                buttonClass := succeeded ? 'collapsed' : ''
                panelClass := succeeded ? '' : 'show'

                testName := "<strong>" . testKey . "</strong> <span class='result-counts' style='margin-left: 0.5em'>(" . this.GetResultCounts(testResults) . ")</span>"

                output .= "<div class='accordion-item test-results'>`n"
                output .= "<h2 class='accordion-header' id='panelHeading" . panelNum . "'>`n"
                output .= "<button class='accordion-button " . buttonClass . "' type='button' data-bs-toggle='collapse' data-bs-target='#panel" . panelNum . "' aria-expanded='false' area-controls='panel" . panelNum . "'>`n"
                output .= "<i class='bi bi-" . icon . " " . color . "' style='margin-right: 0.5em; font-size: 1.5rem;'></i> " . testName . "`n"
                output .= "</button>`n"
                output .= "</h2>`n"
                output .= "<div id='panel" . panelNum . "' class='accordion-collapse collapse " . panelClass . "' aria-labelledby='panelHeading" . panelNum . "'>`n"
                output .= "<div class='accordion-body'>`n"
                output .= this.RenderTestSummary(testResults)
                output .= this.RenderTestResults(testResults)
                output .= "</div>`n"
                output .= "</div>`n"
                output .= "</div>`n"
            }
        }

        output .= "</div>`n"

        return output
    }

    RenderTestTitle(testKey) {
        return "<h2>" . testKey . "</h2>`n"
    }

    TestSucceeded(testResults) {
        successful := true

        if (testResults.Length > 0) {
            for taskName, taskResult in testResults {
                if (!taskResult["success"]) {
                    successful := false
                }
            }
        }

        return successful
    }

    GetResultCounts(testResults) {
        succeededCount := 0

        for taskName, taskResult in testResults {
            if (taskResult["success"]) {
                succeededCount += 1
            }
        }

        return succeededCount . " of " . testResults.Length
    }

    RenderTestSummary(testResults) {
        testStatus := "Successful"
        successful := true
        succeededCount := 0
        totalCount := testResults.Length
        output := ""

        if (totalCount > 0) {
            for taskName, taskResult in testResults {
                if (taskResult["success"]) {
                    succeededCount += 1
                } else {
                    successful := false
                    testStatus := "Failed"
                }
            }
    
            output .= "<dl>`n"
            output .= "`t<dt>Status</dt>`n"
            statusClass := successful ? "text-success" : "text-danger"
            output .= "`t<dd class='" . statusClass . "'>" . testStatus . "</dd>`n"
            output .= "`t<dt>Succeeded</dt>`n"
            output .= "`t<dd>" . succeededCount . " of " . totalCount . "</dd>`n"
            output .= "</dl>`n"
        }
        
        return output
    }

    RenderTestResults(testResults) {
        output := ""

        if (testResults.Length > 0) {
            output .= "<table class='table table-bordered'>`n"
            output .= "`t<tr><th scope='col'>Method</th><th scope='col'>Task</th><th scope='col'>Assertion</th><th scope='col'>Status</th><th scope='col'>Data</th></tr>`n"

            for taskName, taskResult in testResults {
                if (taskResult.Has("description") && taskResult["description"]) {
                    taskName := taskResult["description"]
                }

                dataOutput := ""

                if (taskResult.Has("data") && taskResult["data"] && taskResult["data"].Count > 0) {
                    dataOutput .= "<dl>"

                    for dataKey, dataValue in taskResult["data"] {
                        dataOutput .= "<dt>" . dataKey . "</dt><dd>" . this.ConvertToString(dataValue) . "</dd>"
                    }

                    dataOutput .= "</dl>"
                }

                className := taskResult["success"] ? "table-success" : "table-danger"
                taskStatus := taskResult["success"] ? "Success" : "Failure"

                output .= "`t<tr class='" . className . "'>`n"
                output .= "`t`t<th scope='row'>" . taskResult["method"] . "</th>`n"
                output .= "`t`t<th scope='row'>" . taskName . "</th>`n"
                output .= "`t`t<td>" . taskResult["assertion"] . "</td>`n"
                output .= "`t`t<td>" . taskStatus . "</td>`n"
                output .= "`t`t<td>" . dataOutput . "</td>`n"
                output .= "`t</tr>`n"
            }

            output .= "</table>`n"
        }

        return output
    }
}
