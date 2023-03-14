class HtmlResultViewer extends TemplateFileResultViewerBase {
    fileExt := ".html"
    usesOutputFile := false

    __New(title := "", templateContent := "", outputFile := "", fileExt := "") {
        if (!templateContent) {
            templateContent := this.GetDefaultTemplate()
        }

        super.__New(title, templateContent, outputFile, fileExt)
    }

    GetDefaultTemplate() {
        return '
(
<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <title>{{title}} Results</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script nomodule>window.MSInputMethodContext && document.documentMode && document.write('<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-ie11@5.2.2/css/bootstrap-ie11.min.css" media="all and (-ms-high-contrast: active), (-ms-high-contrast: none)"><script src="https://cdn.jsdelivr.net/combine/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js,npm/ie11-custom-properties@4,npm/element-qsa-scope@1"><\/script><script crossorigin="anonymous" src="https://polyfill.io/v3/polyfill.min.js?features=default%2CNumber.parseInt%2CNumber.parseFloat%2CArray.prototype.find%2CArray.prototype.includes"><\/script>');</script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/css/bootstrap.min.css" crossorigin="anonymous">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">
  <meta name="theme-color" content="#fafafa">
  <style>
    html {
      overflow: auto;
    }
  </style>
</head>

<body class="bg-dark text-light">
    <div class="container pt-4">
        {{results}}

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </div>
</body>

</html>
)'
    }

    DisplayResults() {
        htmlContent := this.rendered

        resultsGui := Gui("+Resize")
        resultsGui.MarginX := 0
        resultsGui.MarginY := 0
        resultsGui.Title := this.testTitle . " Results"
        resultsGui.OnEvent("Size", ObjBindMethod(this, "OnGuiSize"))

        wbControl := resultsGui.Add("ActiveX", "vBrowser w1024 h728", "Shell.Explorer").Value
        wbControl.Navigate("about:<!DOCTYPE html><meta http-equiv='X-UA-Compatible' content='IE=edge'>")
        wbControl.document.write(this.rendered)

        resultsGui.Show()
    }

    OnGuiSize(resultsGui, minMax, width, height) {
        resultsGui["Browser"].Move(0, 0, width, height)
    }

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

        output .= "<div class='row test-results'>`n"
        output .= this.RenderTestTitle("Test Results")
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
                borderClass := succeeded ? 'border-success' : 'border-danger'

                testName := "<strong>" . testKey . "</strong> <span class='result-counts' style='margin-left: 0.5em'>(" . this.GetResultCounts(testResults) . ")</span>"

                output .= "<div class='accordion-item test-results bg-dark text-light " . borderClass . "'>`n"
                output .= "<h2 class='accordion-header' id='panelHeading" . panelNum . "'>`n"
                output .= "<button class='accordion-button bg-dark text-light " . buttonClass . "' type='button' data-bs-toggle='collapse' data-bs-target='#panel" . panelNum . "' aria-expanded='false' area-controls='panel" . panelNum . "'>`n"
                output .= "<i class='bi bi-" . icon . " " . color . "' style='margin-right: 0.5em; font-size: 1.5rem;'></i> " . testName . "`n"
                output .= "</button>`n"
                output .= "</h2>`n"
                output .= "<div id='panel" . panelNum . "' class='accordion-collapse bg-dark text-light collapse " . panelClass . "' aria-labelledby='panelHeading" . panelNum . "'>`n"
                output .= "<div class='accordion-body'>`n"
                output .= this.RenderTestSummary(testResults)
                output .= this.RenderTestResults(testResults)
                output .= "</div>`n"
                output .= "</div>`n"
                output .= "</div>`n"
            }
        }

        output .= "</div></div>`n"

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
            output .= "<div class='table-responsive-lg'><table class='table table-bordered table-dark table-striped table-hover'>`n"
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

                taskStatus := taskResult["success"] ? "Success" : "Failure"
                statusClass := taskResult["success"] ? "text-success" : "text-danger"

                output .= "`t<tr>`n"
                output .= "`t`t<th scope='row'>" . taskResult["method"] . "</th>`n"
                output .= "`t`t<th scope='row'>" . taskName . "</th>`n"
                output .= "`t`t<td>" . taskResult["assertion"] . "</td>`n"
                output .= "`t`t<td class='" . statusClass . "'>" . taskStatus . "</td>`n"
                output .= "`t`t<td>" . dataOutput . "</td>`n"
                output .= "`t</tr>`n"
            }

            output .= "</table></div>`n"
        }

        return output
    }
}
