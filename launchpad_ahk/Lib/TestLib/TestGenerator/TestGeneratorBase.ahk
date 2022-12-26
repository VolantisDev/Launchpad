class TestGeneratorBase {
    baseClass := "TestBase"

    __New(baseClass := "") {
        if (baseClass) {
            this.baseClass := baseClass
        }
    }

    Generate(classFile, overwrite := false) {
        if (!classFile || !FileExist(classFile)) {
            throw FileSystemTestException("Class file " . classFile . " not found.")
        }

        SplitPath(classFile,, classDir,, className)
        testPath := classDir . "\" . className . ".test.ahk"

        if (FileExist(testPath)) {
            if (overwrite) {
                FileDelete(testPath)
            } else {
                throw FileSystemTestException("Test path " . testPath . " already exists.")
            }
        }

        testMethods := this.CollectTestMethods(className)
        this.WriteTestFile(className, testMethods, testPath)
    }

    CollectTestMethods(className) {
        testMethods := []

        for propName in %className%.OwnProps() {
            if propDesc.HasProp('Call') {
                testMethods.Push(propName)
            }
		}

        return testMethods
    }

    WriteTestFile(className, testMethods, testPath) {
        FileAppend("class " . className . "Test extends " . this.baseClass . "{", testPath)
        FileAppend("    CreateTestInstances() {`n`n    }", testPath)

        for testMethod in testMethods {
            FileAppend("`n    Test" . testMethod . "() {`n`n    }", testPath)
        }

        FileAppend("}", testPath)
    }
}
