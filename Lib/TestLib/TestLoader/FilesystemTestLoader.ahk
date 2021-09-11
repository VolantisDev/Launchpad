class FilesystemTestLoader extends TestLoaderBase {
    baseDir := A_ScriptDir
    testExt := ".test.ahk"
    classAppend := "Test"
    classPrepend := ""

    __New(baseDir := "", testExt := "", classAppend := "", classPrepend := "") {
        if (baseDir) {
            this.baseDir := baseDir
        }

        if (testExt) {
            this.testExt := testExt
        }

        if (classAppend) {
            this.classAppend := classAppend
        }

        if (classPrepend) {
            this.classPrepend := classPrepend
        }
    }

    LoadTests() {
        tests := []
        extLen := StrLen(this.testExt)

        Loop Files, this.baseDir . "\*" . this.testExt, "R" {
            if (A_LoopFileName != "Includes.ahk" && A_LoopFileName != "Includes.test.ahk") {
                testClass := this.classPrepend . SubStr(A_LoopFileName, 1, -extLen) . this.classAppend
                tests.Push(%testClass%())
            }
            
        }

        this.tests := tests
    }
}
