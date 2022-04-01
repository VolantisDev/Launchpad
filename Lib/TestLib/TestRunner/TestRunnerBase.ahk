class TestRunnerBase {
    tests := []
    results := Map()

    __New(tests) {
        if (!HasBase(tests, Array.Prototype)) {
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
        test.Setup()
        success := false

        try {
            test.Run()
            success := test.GetSuccessStatus()
        } catch Any {
            success := false
        }
        
        this.results[test.GetKey()] := test.GetResults()
        test.Teardown()
        return success
    }

    GetResults() {
        return this.results
    }
}
