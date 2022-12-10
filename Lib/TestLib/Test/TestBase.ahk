class TestBase extends AssertableBase {
    testDir := ""
    testFinished := false
    testMethodVal := ""

    TestMethod {
        get => this.testMethodVal
        set => this.testMethodVal := value
    }

    __New(tmpDirBase := "") {
        if (!tmpDirBase) {
            tmpDirBase := A_Temp
        }

        this.testDir := tmpDirBase . "\" . this.GetKey()
    }

    Setup() {
        this.CreateTestDir()
        this.CreateTestInstances()
    }

    CreateTestInstances() {
        
    }

    Run() {
        this.RunTestSteps()
        return this.testSuccess
    }

    GetTestSteps() {
        testSteps := []

        for propName in this.Base.OwnProps() {
            if (InStr(propName, "Test", true) == 1) {
                propDesc := this.Base.GetOwnPropDesc(propName)

                if propDesc.HasProp('Call') {
                    testSteps.Push(propName)
                }
            }
		}

        return testSteps
    }

    RunTestSteps() {
        testSteps := this.GetTestSteps()

        if (testSteps.HasBase(Array.Prototype)) {
            for index, params in testSteps {
                methodName := ""

                if (params.HasBase(Array.Prototype)) {
                    methodName := params.RemoveAt(1)
                } else {
                    methodName := params
                    params := ""
                }
                
                if (methodName) {
                    this.RunTestStep(methodName, params)
                }
            }
        }
    }

    RunTestStep(methodName, params := "") {
        testMethod := methodName
        
        if (InStr(methodName, "Test") == 1) {
            testMethod := SubStr(methodName, 5)
        }

        this.TestMethod := testMethod

        if (methodName && this.HasProp(methodName)) {
            methodToCall := this.%methodName%

            if (!params) {
                params := []
            }

            params.InsertAt(1, this)
            methodToCall(params*)
        }

        this.TestMethod := ""
    }

    Teardown() {
        this.testFinished := true
        this.DeleteTestDir()
    }

    CreateTestDir() {
        if (this.testDir) {
            if (DirExist(this.testDir)) {
                DirDelete(this.testDir, true)
            }

            DirCreate(this.testDir)
        }
    }

    DeleteTestDir() {
        if (this.testDir && DirExist(this.testDir)) {
            DirDelete(this.testDir, true)
        }
    }

    GetKey() {
        return SubStr(Type(this), 1, -4)
    }

    GetResults() {
        return this.results
    }

    GetSuccessStatus() {
        return this.testFinished && this.testSuccess
    }
}
