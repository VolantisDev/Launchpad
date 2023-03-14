class TestLoaderBase {
    tests := []
    testsLoaded := false

    GetTests() {
        if (!this.testsLoaded) {
            this.LoadTests()
            this.testsLoaded := true
        }

        return this.tests
    }

    LoadTests() {
        throw NotImplementedTestException("The LoadTests method has not been implemented.")
    }
}
