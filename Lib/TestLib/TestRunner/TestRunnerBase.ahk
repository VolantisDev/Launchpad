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
        test.Setup()
        success := false

        try {
            success := test.Run()
        } catch any {
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
