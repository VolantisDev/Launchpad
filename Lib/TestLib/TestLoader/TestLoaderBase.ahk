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
        throw MethodNotImplementedException("TestLoaderBase", "LoadTests")
    }
}
