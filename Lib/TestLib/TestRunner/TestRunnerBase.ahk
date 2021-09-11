class TestRunnerBase {
    tests := []
    results := Map()

    __New(tests) {
        if (Type(tests) != "Array") {
            tests := [tests]
        }

        this.tests := tests
    }

    RunTests() {
        for index, test in this.tests {
            this.RunTest(test)
        }

        return this.results
    }

    RunTest(test) {
        success := test.Run()
        results[test.GetKey()] := test.GetResults()
        return success
    }

    GetResults() {
        return this.results
    }

    PrintResults() {
        ; TODO: Pretty-print the results of each task within each test
    }
}
